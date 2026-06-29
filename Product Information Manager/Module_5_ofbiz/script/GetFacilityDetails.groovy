import org.apache.ofbiz.entity.util.EntityUtil
import org.apache.ofbiz.base.util.UtilDateTime

facilityId = parameters.facilityId
context.facilityId = facilityId

def pimFacility = delegator.findOne("PimFacility", [facilityId: facilityId], false)
context.pimFacility = pimFacility

if (pimFacility) {
    // Get locations
    context.facilityLocationList = delegator.findByAnd("PimFacilityLocation", [facilityId: facilityId], ["locationSeqId"], false)

    // Get facility parties with names
    def fpList = delegator.findByAnd("PimFacilityParty", [facilityId: facilityId], ["roleTypeId"], false)
    def partyList = []
    for (fp in fpList) {
        def name = ""
        def person = delegator.findOne("RmPerson", [partyId: fp.partyId], false)
        if (person) {
            name = "${person.firstName} ${person.lastName}"
        } else {
            def org = delegator.findOne("RmOrganization", [partyId: fp.partyId], false)
            if (org) {
                name = org.organizationName ?: ""
            }
        }
        partyList.add([
            facilityId: fp.facilityId,
            partyId: fp.partyId,
            roleTypeId: fp.roleTypeId,
            partyName: name
        ])
    }
    context.facilityPartyList = partyList

    // Get group members
    context.facilityGroupMemberList = delegator.findByAnd("PimFacilityGroupMember", [facilityId: facilityId], ["facilityGroupId"], false)

    // Get contact mechs with purpose and detailed display string
    def fcmList = delegator.findByAnd("PimFacilityContactMech", [facilityId: facilityId], ["fromDate DESC"], false)
    def contactList = []
    for (fcm in fcmList) {
        def details = [:]
        details.facilityId = fcm.facilityId
        details.contactMechId = fcm.contactMechId
        details.contactMechPurposeTypeId = fcm.contactMechPurposeTypeId
        details.fromDate = fcm.fromDate
        details.thruDate = fcm.thruDate

        def cm = delegator.findOne("RmContactMech", [contactMechId: fcm.contactMechId], false)
        if (cm) {
            details.contactMechTypeId = cm.contactMechTypeId
            if (cm.contactMechTypeId == "TELECOM_NUMBER") {
                def tel = delegator.findOne("RmTelecomNumber", [contactMechId: fcm.contactMechId], false)
                if (tel) {
                    details.displayInfo = "${tel.countryCode ?: ''}-${tel.areaCode ?: ''}-${tel.contactNumber ?: ''}"
                }
            } else if (cm.contactMechTypeId == "POSTAL_ADDRESS") {
                def post = delegator.findOne("RmPostalAddress", [contactMechId: fcm.contactMechId], false)
                if (post) {
                    details.displayInfo = "${post.toName ?: ''} / ${post.address1 ?: ''}, ${post.city ?: ''}"
                }
            } else {
                details.displayInfo = cm.infoString ?: ""
            }
        }
        contactList.add(details)
    }
    context.facilityContactMechList = contactList
}
