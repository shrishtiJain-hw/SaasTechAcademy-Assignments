import org.apache.ofbiz.service.ServiceUtil

Map serviceCtx = [:]

if (parameters.orderId) serviceCtx.orderId = parameters.orderId
if (parameters.customerName) serviceCtx.customerName = parameters.customerName
if (parameters.fromDate) serviceCtx.fromDate = parameters.fromDate
if (parameters.thruDate) serviceCtx.thruDate = parameters.thruDate
if (parameters.statusId) serviceCtx.statusId = parameters.statusId
if (parameters.paymentStatus) serviceCtx.paymentStatus = parameters.paymentStatus
if (parameters.shippingAddress) serviceCtx.shippingAddress = parameters.shippingAddress

int viewIndex = 0
int viewSize = 20

if (parameters.viewIndex) {
    try {
        viewIndex = Integer.parseInt(parameters.viewIndex)
    } catch (Exception e) {
        // use default
    }
}
if (parameters.viewSize) {
    try {
        viewSize = Integer.parseInt(parameters.viewSize)
    } catch (Exception e) {
        // use default
    }
}

serviceCtx.viewIndex = viewIndex
serviceCtx.viewSize = viewSize

Map result = dispatcher.runSync("findOrder", serviceCtx)

if (ServiceUtil.isSuccess(result)) {
    context.orderList = result.orderList
    context.orderListSize = result.orderListSize
    context.viewIndex = result.viewIndex
    context.viewSize = result.viewSize
} else {
    context.orderList = []
    context.orderListSize = 0
    context.viewIndex = viewIndex
    context.viewSize = viewSize
}
