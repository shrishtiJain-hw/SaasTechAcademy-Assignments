import org.apache.ofbiz.base.util.UtilDateTime
import org.apache.ofbiz.service.ServiceUtil

def expireProductCategoryMember() {
    def pcm = delegator.findOne("PimProductCategoryMember", [
        productId: parameters.productId,
        productCategoryId: parameters.productCategoryId,
        fromDate: parameters.fromDate
    ], false)
    
    if (pcm) {
        pcm.thruDate = UtilDateTime.nowTimestamp()
        pcm.store()
    }
    return ServiceUtil.returnSuccess()
}

def expireProductFeatureAppl() {
    def pfa = delegator.findOne("PimProductFeatureAppl", [
        productId: parameters.productId,
        productFeatureId: parameters.productFeatureId,
        fromDate: parameters.fromDate
    ], false)
    
    if (pfa) {
        pfa.thruDate = UtilDateTime.nowTimestamp()
        pfa.store()
    }
    return ServiceUtil.returnSuccess()
}

def expireFacilityContactMech() {
    def fcm = delegator.findOne("PimFacilityContactMech", [
        facilityId: parameters.facilityId,
        contactMechId: parameters.contactMechId,
        contactMechPurposeTypeId: parameters.contactMechPurposeTypeId,
        fromDate: parameters.fromDate
    ], false)
    
    if (fcm) {
        fcm.thruDate = UtilDateTime.nowTimestamp()
        fcm.store()
    }
    return ServiceUtil.returnSuccess()
}
