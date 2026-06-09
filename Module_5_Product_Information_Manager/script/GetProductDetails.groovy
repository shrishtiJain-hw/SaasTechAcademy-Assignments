import org.apache.ofbiz.entity.util.EntityUtil
import org.apache.ofbiz.base.util.UtilDateTime

productId = parameters.productId
context.productId = productId

def pimProduct = delegator.findOne("PimProduct", [productId: productId], false)
context.pimProduct = pimProduct

if (pimProduct) {
    // Get product contents
    context.productContentList = delegator.findByAnd("PimProductContent", [productId: productId], ["productContentTypeId"], false)

    // Get pricing
    context.productPriceList = delegator.findByAnd("PimProductPrice", [productId: productId], ["productPriceTypeId"], false)

    // Get dimensions
    context.productDimensionList = delegator.findByAnd("PimProductDimension", [productId: productId], ["dimensionTypeId"], false)

    // Get product category members with category details
    def pcmList = delegator.findByAnd("PimProductCategoryMember", [productId: productId], ["fromDate DESC"], false)
    def categoryList = []
    for (pcm in pcmList) {
        def details = [:]
        details.productId = pcm.productId
        details.productCategoryId = pcm.productCategoryId
        details.fromDate = pcm.fromDate
        details.thruDate = pcm.thruDate
        
        def cat = delegator.findOne("PimProductCategory", [productCategoryId: pcm.productCategoryId], false)
        if (cat) {
            details.categoryName = cat.categoryName ?: ""
            details.productCategoryTypeId = cat.productCategoryTypeId ?: ""
        }
        categoryList.add(details)
    }
    context.productCategoryList = categoryList

    // Get product feature applications with feature details
    def pfaList = delegator.findByAnd("PimProductFeatureAppl", [productId: productId], ["fromDate DESC"], false)
    def featureList = []
    for (pfa in pfaList) {
        def details = [:]
        details.productId = pfa.productId
        details.productFeatureId = pfa.productFeatureId
        details.fromDate = pfa.fromDate
        details.thruDate = pfa.thruDate
        details.applTypeEnumId = pfa.applTypeEnumId ?: ""
        
        def feat = delegator.findOne("PimProductFeature", [productFeatureId: pfa.productFeatureId], false)
        if (feat) {
            details.productFeatureTypeId = feat.productFeatureTypeId ?: ""
        }
        featureList.add(details)
    }
    context.productFeatureList = featureList

    // Get associations where product is the source
    context.productAssocList = delegator.findByAnd("PimProductAssoc", [productId: productId], ["fromDate DESC"], false)

    // Get associations where product is the target
    context.productTargetAssocList = delegator.findByAnd("PimProductAssoc", [toProductId: productId], ["fromDate DESC"], false)

    // Get facilities where product is stocked
    def pfList = delegator.findByAnd("PimProductFacility", [productId: productId], ["facilityId"], false)
    context.productFacilityList = pfList

    // Get stock locations
    context.productFacilityLocationList = delegator.findByAnd("PimProductFacilityLocation", [productId: productId], ["facilityId", "locationSeqId"], false)
}
