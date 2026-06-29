import org.apache.ofbiz.entity.util.EntityUtil
import org.apache.ofbiz.base.util.UtilDateTime

partyId = parameters.partyId
context.partyId = partyId

party = delegator.findOne("RmParty", [partyId: partyId], false)
context.party = party

if (party) {
    if (party.partyTypeId == "PERSON") {
        context.rmPerson = delegator.findOne("RmPerson", [partyId: partyId], false)
    } else if (party.partyTypeId == "ORGANIZATION") {
        context.rmOrganization = delegator.findOne("RmOrganization", [partyId: partyId], false)
    }

    // Get roles
    context.partyRoles = delegator.findByAnd("RmPartyRole", [partyId: partyId], ["roleTypeId"], false)

    // Get contact mechanisms
    List partyContactMechs = delegator.findByAnd("RmPartyContactMech", [partyId: partyId], ["fromDate DESC"], false)
    List contactMechsList = []
    for (pcm in partyContactMechs) {
        Map cmDetails = [:]
        cmDetails.partyId = pcm.partyId
        cmDetails.contactMechId = pcm.contactMechId
        cmDetails.contactMechPurposeId = pcm.contactMechPurposeId
        cmDetails.fromDate = pcm.fromDate
        cmDetails.thruDate = pcm.thruDate

        // Check if expired
        boolean isExpired = pcm.thruDate != null && pcm.thruDate.before(UtilDateTime.nowTimestamp())
        cmDetails.isExpired = isExpired

        def cm = delegator.findOne("RmContactMech", [contactMechId: pcm.contactMechId], false)
        if (cm) {
            cmDetails.contactMechTypeId = cm.contactMechTypeId
            cmDetails.infoString = cm.infoString ?: ""

            if (cm.contactMechTypeId == "TELECOM_NUMBER") {
                def tel = delegator.findOne("RmTelecomNumber", [contactMechId: pcm.contactMechId], false)
                if (tel) {
                    cmDetails.countryCode = tel.countryCode ?: ""
                    cmDetails.areaCode = tel.areaCode ?: ""
                    cmDetails.contactNumber = tel.contactNumber ?: ""
                    cmDetails.displayInfo = "${cmDetails.countryCode}-${cmDetails.areaCode}-${cmDetails.contactNumber}"
                }
            } else if (cm.contactMechTypeId == "POSTAL_ADDRESS") {
                def post = delegator.findOne("RmPostalAddress", [contactMechId: pcm.contactMechId], false)
                if (post) {
                    cmDetails.toName = post.toName ?: ""
                    cmDetails.attnName = post.attnName ?: ""
                    cmDetails.address1 = post.address1 ?: ""
                    cmDetails.address2 = post.address2 ?: ""
                    cmDetails.city = post.city ?: ""
                    cmDetails.postalCode = post.postalCode ?: ""
                    cmDetails.displayInfo = "${cmDetails.toName} / ${cmDetails.address1} ${cmDetails.address2}, ${cmDetails.city} ${cmDetails.postalCode}"
                }
            } else {
                cmDetails.displayInfo = cmDetails.infoString
            }
        }
        contactMechsList.add(cmDetails)
    }
    context.contactMechsList = contactMechsList
}
