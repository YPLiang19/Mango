//
//  MANBlock.m
//  mangoExample
//
//  Created by jerry.yong on 2017/12/26.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MANBlock.h"
#import "ffi.h"
#import "util.h"
#import "execute.h"




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
	MANBlock *mangoBlock = (__bridge MANBlock *)userdata;
	MANInterpreter *inter = mangoBlock.inter;
	MANScopeChain *scope = mangoBlock.scope;
	MANFunctionDefinition *func = mangoBlock.func;
	NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:mangoBlock.typeEncoding];
	NSUInteger numberOfArguments = [sig numberOfArguments];
	NSMutableArray *argValues = [NSMutableArray array];
	for (NSUInteger i = 1; i < numberOfArguments ; i++) {
		void *arg = args[i];
		MANValue *argValue = [[MANValue alloc] initWithCValuePointer:arg typeEncoding:[sig getArgumentTypeAtIndex:i] bridgeTransfer:NO];
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
	struct MANGOSimulateBlockDescriptor *_descriptor;
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
	
	
	struct MANGOSimulateBlockDescriptor descriptor = {
		0,
		sizeof(struct MANSimulateBlock),
		(void (*)(void *dst, const void *src))copy_helper,
		(void (*)(const void *src))dispose_helper,
		typeEncoding
	};
	struct MANGOSimulateBlockDescriptor *descriptorPtr = malloc(sizeof(struct MANGOSimulateBlockDescriptor));
	memcpy(descriptorPtr, &descriptor, sizeof(struct MANGOSimulateBlockDescriptor));
	
	struct MANSimulateBlock simulateBlock = {
		&_NSConcreteStackBlock,
		(BLOCK_HAS_COPY_DISPOSE | BLOCK_HAS_SIGNATURE | BLOCK_CREATED_FROM_MANGO),
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
