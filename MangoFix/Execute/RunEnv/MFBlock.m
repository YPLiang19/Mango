//
//  MFBlock.m
//  MangoFix
//
//  Created by jerry.yong on 2017/12/26.
//  Copyright © 2017年 yongpengliang. All rights reserved.
//

#import "MFBlock.h"
#import "ffi.h"
#import "util.h"
#import "execute.h"
#import "MFValue+Private.h"




void copy_helper(struct MFSimulateBlock *dst, struct MFSimulateBlock *src)
{
	// do not copy anything is this funcion! just retain if need.
	CFRetain(dst->wrapper);
}

void dispose_helper(struct MFSimulateBlock *src)
{
	free((void *)src->descriptor->signature);
	CFRelease(src->wrapper);
}



static void blockInter(ffi_cif *cif, void *ret, void **args, void *userdata){
	MFBlock *mangoBlock = (__bridge MFBlock *)userdata;
	MFInterpreter *inter = mangoBlock.inter;
	MFScopeChain *scope = [MFScopeChain scopeChainWithNext:mangoBlock.outScope];
	MFFunctionDefinition *func = mangoBlock.func;
	NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:mangoBlock.typeEncoding];
	NSUInteger numberOfArguments = [sig numberOfArguments];
	NSMutableArray *argValues = [NSMutableArray array];
	for (NSUInteger i = 1; i < numberOfArguments ; i++) {
		void *arg = args[i];
		MFValue *argValue = [[MFValue alloc] initWithCValuePointer:arg typeEncoding:[sig getArgumentTypeAtIndex:i] bridgeTransfer:NO];
		[argValues addObject:argValue];
		
	}
	__autoreleasing MFValue *retValue = mf_call_mf_function(inter, scope, func, argValues);
	[retValue assignToCValuePointer:ret typeEncoding:[sig methodReturnType]];
}

@implementation MFBlock{
	ffi_cif *_cifPtr;
	ffi_type **_args;
	ffi_closure *_closure;
	BOOL _generatedPtr;
	void *_blockPtr;
	struct MFGOSimulateBlockDescriptor *_descriptor;
}

+ (const char *)typeEncodingForBlock:(id)block{
	struct MFSimulateBlock *blockRef = (__bridge struct MFSimulateBlock *)block;
	int flags = blockRef->flags;
	
	if (flags & BLOCK_HAS_SIGNATURE) {
		void *signatureLocation = blockRef->descriptor;
		signatureLocation += sizeof(size_t);
		signatureLocation += sizeof(size_t);
		
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
	
	ffi_type *returnType = mf_ffi_type_with_type_encoding(sig.methodReturnType);
	
	_args = malloc(sizeof(ffi_type *) * argCount);
	for (int  i = 0 ; i < argCount; i++) {
		_args[i] = mf_ffi_type_with_type_encoding([sig getArgumentTypeAtIndex:i]);
	}
	
	_cifPtr = malloc(sizeof(ffi_cif));
	ffi_prep_cif(_cifPtr, FFI_DEFAULT_ABI, argCount, returnType, _args);
	_closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&blockImp);
	ffi_prep_closure_loc(_closure, _cifPtr, blockInter, (__bridge void *)self, blockImp);
	
	
	struct MFGOSimulateBlockDescriptor descriptor = {
		0,
		sizeof(struct MFSimulateBlock),
		(void (*)(void *dst, const void *src))copy_helper,
		(void (*)(const void *src))dispose_helper,
		typeEncoding
	};
	_descriptor = malloc(sizeof(struct MFGOSimulateBlockDescriptor));
	memcpy(_descriptor, &descriptor, sizeof(struct MFGOSimulateBlockDescriptor));
	
	struct MFSimulateBlock simulateBlock = {
		&_NSConcreteStackBlock,
		(BLOCK_HAS_COPY_DISPOSE | BLOCK_HAS_SIGNATURE | BLOCK_CREATED_FROM_MFGO),
		0,
		blockImp,
		_descriptor,
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
