import { util } from "@aws-appsync/utils";

export function request(ctx) {
  const { source, args } = ctx;
  return {
    operation: "Invoke",
    payload: { field: ctx.info.fieldName, arguments: args, source },
  };
}

// the Post.relatedPosts response handler
export function response(ctx) {
  // util.error("Failed to fetch relatedPosts", "LambdaFailure", ctx.result);
  return ctx.result;
}
