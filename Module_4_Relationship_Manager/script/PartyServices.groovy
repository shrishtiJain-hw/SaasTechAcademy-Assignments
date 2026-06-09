import org.apache.ofbiz.base.util.*
import org.apache.ofbiz.entity.*
import java.sql.Date

def createPerson() {
    delegator.create("RmParty", [
        partyId    : parameters.partyId,
        partyTypeId: "PERSON"
    ])

    delegator.create("RmPerson", [
        partyId  : parameters.partyId,
        firstName: parameters.firstName,
        lastName : parameters.lastName,
        birthDate: parameters.birthDate ? Date.valueOf(parameters.birthDate) : null
    ])

    return success()
}

def updatePerson() {
    def person = delegator.findOne("RmPerson", [partyId: parameters.partyId], false)
    if (person) {
        if (parameters.firstName) person.firstName = parameters.firstName
        if (parameters.lastName) person.lastName = parameters.lastName
        if (parameters.birthDate) {
            person.birthDate = Date.valueOf(parameters.birthDate)
        }
        person.store()
    }
    return success()
}

def createOrganization() {
    delegator.create("RmParty", [
        partyId    : parameters.partyId,
        partyTypeId: "ORGANIZATION"
    ])

    delegator.create("RmOrganization", [
        partyId         : parameters.partyId,
        organizationName: parameters.organizationName
    ])

    return success()
}

def updateOrganization() {
    def org = delegator.findOne("RmOrganization", [partyId: parameters.partyId], false)
    if (org) {
        if (parameters.organizationName) org.organizationName = parameters.organizationName
        org.store()
    }
    return success()
}

def createContactMech() {
    String contactMechId = delegator.getNextSeqId("RmContactMech")

    // Create RmContactMech
    delegator.create("RmContactMech", [
        contactMechId: contactMechId,
        contactMechTypeId: parameters.contactMechTypeId,
        infoString: parameters.infoString
    ])

    if ("TELECOM_NUMBER" == parameters.contactMechTypeId) {
        delegator.create("RmTelecomNumber", [
            contactMechId: contactMechId,
            countryCode: parameters.countryCode,
            areaCode: parameters.areaCode,
            contactNumber: parameters.contactNumber
        ])
    } else if ("POSTAL_ADDRESS" == parameters.contactMechTypeId) {
        delegator.create("RmPostalAddress", [
            contactMechId: contactMechId,
            toName: parameters.toName,
            attnName: parameters.attnName,
            address1: parameters.address1,
            address2: parameters.address2,
            city: parameters.city,
            postalCode: parameters.postalCode
        ])
    }

    // Create RmPartyContactMech
    delegator.create("RmPartyContactMech", [
        partyId: parameters.partyId,
        contactMechId: contactMechId,
        contactMechPurposeId: parameters.contactMechPurposeId,
        fromDate: UtilDateTime.nowTimestamp()
    ])

    Map result = success()
    result.put("contactMechId", contactMechId)
    return result
}

def expirePartyContactMech() {
    def partyContactMech = delegator.findOne("RmPartyContactMech", [
        partyId: parameters.partyId,
        contactMechId: parameters.contactMechId,
        contactMechPurposeId: parameters.contactMechPurposeId,
        fromDate: parameters.fromDate
    ], false)
    if (partyContactMech) {
        partyContactMech.thruDate = UtilDateTime.nowTimestamp()
        partyContactMech.store()
    }
    return success()
}