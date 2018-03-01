//
//  MANBlock.m
//  ananasExample
//
//  Created by jerry.yong on 2017/12/26.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MANBlock.h"
#import "ffi.h"
#import "util.h"
#import "execute.h"

enum {
	BLOCK_DEALLOCATING =      (0x0001),
	BLOCK_REFCOUNT_MASK =     (0xfffe),
	BLOCK_NEEDS_FREE =        (1 << 24),
	BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
	BLOCK_HAS_CTOR =          (1 << 26),
	BLOCK_IS_GC =             (1 << 27),
	BLOCK_IS_GLOBAL =         (1 << 28),
	BLOCK_USE_STRET =         (1 << 29),
	BLOCK_HAS_SIGNATURE  =    (1 << 30)
};

struct MANSimulateBlock {
	void *isa;
	int flags;
	int reserved;
	void *invoke;
	struct ANANASSimulateBlockDescriptor *descriptor;
	void *wrapper;
};

struct ANANASSimulateBlockDescriptor {
	//Block_descriptor_1
	struct {
		unsigned long int reserved;
		unsigned long int size;
	};
	
	//Block_descriptor_2
	struct {
		// requires BLOCK_HAS_COPY_DISPOSE
		void (*copy)(void *dst, const void *src);
		void (*dispose)(const void *);
	};
	
	//Block_descriptor_3
	struct {
		// requires BLOCK_HAS_SIGNATURE
		const char *signature;
	};
};

void copy_helper(struct MANSimulateBlock *dst, struct MANSimulateBlock *src)
{
	// do not copy anything is this funcion! just retain if need.
		CFRetain(dst->wrapper);
}

void dispose_helper(struct MANSimulateBlock *src)
{
		CFRelease(src->wrapper);
}



static void blockInter(ffi_cif *cif, void *ret, void **args, void *userdata){
	MANBlock *anananBlock = (__bridge MANBlock *)userdata;
	MANInterpreter *inter = anananBlock.inter;
	MANScopeChain *scope = anananBlock.scope;
	MANFunctionDefinition *func = anananBlock.func;
	NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:anananBlock.typeEncoding];
	NSUInteger numberOfArguments = [sig numberOfArguments];
	NSMutableArray *argValues = [NSMutableArray array];
	for (NSUInteger i = 1; i < numberOfArguments ; i++) {
		void *arg = args[i];
		MANValue *argValue = [[MANValue alloc] initWithCValuePointer:arg typeEncoding:[sig getArgumentTypeAtIndex:i]];
		[argValues addObject:argValue];
		
	}
	MANValue *retValue = mango_call_mango_function(inter, scope, func, argValues);
	[retValue assign2CValuePointer:ret typeEncoding:[sig methodReturnType]];
}

@implementation MANBlock{
	ffi_cif *_cifPtr;
	ffi_type **_args;
	ffi_closure *_closure;
	BOOL _generatedPtr;
	void *_blockPtr;
	struct ANANASSimulateBlockDescriptor *_descriptor;
}

+ (const char *)typeEncodingForBlock:(id)block{
	struct MANSimulateBlock *blockRef = (__bridge struct MANSimulateBlock *)block;
	int flags = blockRef->flags;
	
	if (flags & BLOCK_HAS_SIGNATURE) {
		void *signatureLocation = blockRef->descriptor;
		signatureLocation += sizeof(unsigned long int);
		signatureLocation += sizeof(unsigned long int);
		
		if (flags & BLOCK_HAS_COPY_DISPOSE) {
			signatureLocation += sizeof(void(*)(void *dst, void *src));
			signatureLocation += sizeof(void (*)(void *src));
		}
		
		const char *signature = (*(const char **)signatureLocation);
		return signature;
	}
	return NULL;
}

- (id)ocBlock{
	return [self blockPtr];
}

- (void *)blockPtr{
	
	if (_generatedPtr) {
		return _blockPtr;
	}
	_generatedPtr = YES;
	
	void *blockImp = NULL;
	const char *typeEncoding = self.typeEncoding;
	NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:typeEncoding];
	unsigned int argCount = (unsigned int)[sig numberOfArguments];
	
	ffi_type *returnType = mango_ffi_type_with_type_encoding(sig.methodReturnType);
	
	_args = malloc(sizeof(ffi_type *) * argCount);
	for (int  i = 0 ; i < argCount; i++) {
		_args[i] = mango_ffi_type_with_type_encoding([sig getArgumentTypeAtIndex:i]);
	}
	
	_cifPtr = malloc(sizeof(ffi_cif));
	ffi_prep_cif(_cifPtr, FFI_DEFAULT_ABI, argCount, returnType, _args);
	_closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&blockImp);
	ffi_prep_closure_loc(_closure, _cifPtr, blockInter, (__bridge void *)self, blockImp);
	
	
	struct ANANASSimulateBlockDescriptor descriptor = {
		0,
		sizeof(struct MANSimulateBlock),
		(void (*)(void *dst, const void *src))copy_helper,
		(void (*)(const void *src))dispose_helper,
		typeEncoding
	};
	struct ANANASSimulateBlockDescriptor *descriptorPtr = malloc(sizeof(struct ANANASSimulateBlockDescriptor));
	memcpy(descriptorPtr, &descriptor, sizeof(struct ANANASSimulateBlockDescriptor));
	
	struct MANSimulateBlock simulateBlock = {
		&_NSConcreteStackBlock,
		(BLOCK_HAS_COPY_DISPOSE | BLOCK_HAS_SIGNATURE),
		0,
		blockImp,
		descriptorPtr,
		(__bridge void*)self
	};
	_blockPtr = Block_copy(&simulateBlock);
	return _blockPtr;
}

-(void)dealloc{
	ffi_closure_free(_closure);
	free(_args);
	free(_cifPtr);
	free(_descriptor);
	return;
}

@end
