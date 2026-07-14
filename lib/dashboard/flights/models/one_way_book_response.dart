// To parse this JSON data, do
//
//     final flightOnewayBookResponse = flightOnewayBookResponseFromJson(jsonString);

import 'dart:convert';

FlightOnewayBookResponse flightOnewayBookResponseFromJson(String str) => FlightOnewayBookResponse.fromJson(json.decode(str));

String flightOnewayBookResponseToJson(FlightOnewayBookResponse data) => json.encode(data.toJson());

class FlightOnewayBookResponse {
    int statusCode;
    Charges charges;
    String message;

    FlightOnewayBookResponse({
        required this.statusCode,
        required this.charges,
        required this.message,
    });

    factory FlightOnewayBookResponse.fromJson(Map<String, dynamic> json) => FlightOnewayBookResponse(
        statusCode: json["statusCode"],
        charges: Charges.fromJson(json["charges"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "charges": charges.toJson(),
        "message": message,
    };
}

class Charges {
    // PromoData promoData;
    // ConvienenceData convienenceData;
    TicketAllData ticketAllData;

    Charges({
        // required this.promoData,
        // required this.convienenceData,
        required this.ticketAllData,
    });

    factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        // promoData: PromoData.fromJson(json["promoData"]),
        // convienenceData: ConvienenceData.fromJson(json["convienenceData"]),
        ticketAllData: TicketAllData.fromJson(json["ticketAllData"]),
    );

    Map<String, dynamic> toJson() => {
        // "promoData": promoData.toJson(),
        // "convienenceData": convienenceData.toJson(),
        "ticketAllData": ticketAllData.toJson(),
    };
}

class ConvienenceData {
    int type;
    int amount;

    ConvienenceData({
        required this.type,
        required this.amount,
    });

    factory ConvienenceData.fromJson(Map<String, dynamic> json) => ConvienenceData(
        type: json["type"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "amount": amount,
    };
}

class PromoData {
    int promoId;
    bool status;
    int discount;

    PromoData({
        required this.promoId,
        required this.status,
        required this.discount,
    });

    factory PromoData.fromJson(Map<String, dynamic> json) => PromoData(
        promoId: json["PromoID"],
        status: json["status"],
        discount: json["Discount"],
    );

    Map<String, dynamic> toJson() => {
        "PromoID": promoId,
        "status": status,
        "Discount": discount,
    };
}

class TicketAllData {
    // String mappingType;
    // int totalPrice;
    // String couponAmount;
    // int commission;
    // String invoiceNo;
    // int postMarkup;
    String referenceNumber;//
    // String traceId;
    // String type;
    DateTime bookingDate;//
    // String role;
    // String provider;
    String ticketAllDataOperator;
    // String returnOperator;
    // String tripType;
    String fareType;//
    String pnr;//
    // String coupanType;
    // int userId;
    // int roleId;
    String bookingStatus;//
    // int ticketAllDataBookingStatus;
    // Pax pax;
    // String from;
    // String to;
    // String departure;
    // String arrival;
    // PromoData promoData;
    // ConvienenceData convienenceData;
    // String currency;
    // int currencyRatio;
    // dynamic insuranceData;
    // int insuranceRequired;
    DateTime journeyDate;//
    // String operatorName;
    // String description;
    // String pickUpLocation;
    // String dropLocation;
    // String guestName;
    // String guestEmaiId;
    // String guestMobileNo;
    // String promoId;
    List<Passenger> passengers;//
    List<OneWaySegment> oneWaySegment;//
    List<OneWaySegment> returnSegment;
    // List<dynamic> multiDestinationSegment;
    YflightFare oneWayflightFare;//
    CardInfo returnflightFare;
    // YflightFare multicityflightFare;
    List<OneWayBaggageInfo> oneWayBaggageInfo;//
    List<dynamic> returnBaggageInfo;
    // List<dynamic> multiDestinationBaggage;
    CardInfo cardInfo;
    // int markup;
    // String bookedBy;
    // String agentId;
    // int membershipId;
    // bool cancellable;
    // String refundAmount;
    // String cancellationCharges;
    // List<GstDetail> gstDetails;
    // List<dynamic> adminDetails;
    // AgentDetails agentDetails;

    TicketAllData({
        // required this.mappingType,
        // required this.totalPrice,
        // required this.couponAmount,
        // required this.commission,
        // required this.invoiceNo,
        // required this.postMarkup,
        required this.referenceNumber,//
        // required this.traceId,
        // required this.type,
        required this.bookingDate,
        // required this.role,
        // required this.provider,
        required this.ticketAllDataOperator,
        // required this.returnOperator,
        // required this.tripType,
        required this.fareType,
        required this.pnr,//
        // required this.coupanType,
        // required this.userId,
        // required this.roleId,
        required this.bookingStatus,
        // required this.ticketAllDataBookingStatus,
        // required this.pax,
        // required this.from,
        // required this.to,
        // required this.departure,
        // required this.arrival,
        // required this.promoData,
        // required this.convienenceData,
        // required this.currency,
        // required this.currencyRatio,
        // required this.insuranceData,
        // required this.insuranceRequired,
        required this.journeyDate,
        // required this.operatorName,
        // required this.description,
        // required this.pickUpLocation,
        // required this.dropLocation,
        // required this.guestName,
        // required this.guestEmaiId,
        // required this.guestMobileNo,
        // required this.promoId,
        required this.passengers,
        required this.oneWaySegment,
        required this.returnSegment,
        // required this.multiDestinationSegment,
        required this.oneWayflightFare,//
        required this.returnflightFare,
        // required this.multicityflightFare,
        required this.oneWayBaggageInfo,
        required this.returnBaggageInfo,
        // required this.multiDestinationBaggage,
        required this.cardInfo,
        // required this.markup,
        // required this.bookedBy,
        // required this.agentId,
        // required this.membershipId,
        // required this.cancellable,
        // required this.refundAmount,
        // required this.cancellationCharges,
        // required this.gstDetails,
        // required this.adminDetails,
        // required this.agentDetails,
    });

    factory TicketAllData.fromJson(Map<String, dynamic> json) => TicketAllData(
        // mappingType: json["mappingType"],
        // totalPrice: json["totalPrice"],
        // couponAmount: json["couponAmount"],
        // commission: json["commission"],
        // invoiceNo: json["invoiceNo"],
        // postMarkup: json["postMarkup"],
        referenceNumber: json["referenceNumber"],
        // traceId: json["traceId"],
        // type: json["type"],
        bookingDate: DateTime.parse(json["bookingDate"]),
        // role: json["Role"],
        // provider: json["provider"],
        ticketAllDataOperator: json["operator"],
        // returnOperator: json["returnOperator"],
        // tripType: json["tripType"],
        fareType: json["fareType"],
        pnr: json["pnr"],
        // coupanType: json["coupanType"],
        // userId: json["UserId"],
        // roleId: json["RoleId"],
        bookingStatus: json["BookingStatus"],
        // ticketAllDataBookingStatus: json["bookingStatus"],
        // pax: Pax.fromJson(json["pax"]),
        // from: json["from"],
        // to: json["to"],
        // departure: json["departure"],
        // arrival: json["arrival"],
        // promoData: PromoData.fromJson(json["promoData"]),
        // convienenceData: ConvienenceData.fromJson(json["convienenceData"]),
        // currency: json["currency"],
        // currencyRatio: json["currencyRatio"],
        // insuranceData: json["insuranceData"],
        // insuranceRequired: json["insuranceRequired"],
        journeyDate: DateTime.parse(json["journeyDate"]),
        // operatorName: json["operatorName"],
        // description: json["description"],
        // pickUpLocation: json["pickUpLocation"],
        // dropLocation: json["dropLocation"],
        // guestName: json["guestName"],
        // guestEmaiId: json["guestEmaiId"],
        // guestMobileNo: json["guestMobileNo"],
        // promoId: json["promoId"],
        passengers: List<Passenger>.from(json["passengers"].map((x) => Passenger.fromJson(x))),
        oneWaySegment: List<OneWaySegment>.from(json["oneWaySegment"].map((x) => OneWaySegment.fromJson(x))),
        returnSegment: List<OneWaySegment>.from(json["returnSegment"].map((x) =>OneWaySegment.fromJson(x))),
        // multiDestinationSegment: List<dynamic>.from(json["multiDestinationSegment"].map((x) => x)),
        oneWayflightFare: YflightFare.fromJson(json["oneWayflightFare"]),
        returnflightFare: CardInfo.fromJson(json["returnflightFare"]),
        // multicityflightFare: YflightFare.fromJson(json["multicityflightFare"]),
        oneWayBaggageInfo: List<OneWayBaggageInfo>.from(json["oneWayBaggageInfo"].map((x) => OneWayBaggageInfo.fromJson(x))),
        returnBaggageInfo: List<dynamic>.from(json["returnBaggageInfo"].map((x) => x)),
        // multiDestinationBaggage: List<dynamic>.from(json["multiDestinationBaggage"].map((x) => x)),
        cardInfo: CardInfo.fromJson(json["cardInfo"]),
        // markup: json["markup"],
        // bookedBy: json["BookedBy"],
        // agentId: json["AgentID"],
        // membershipId: json["MembershipID"],
        // cancellable: json["cancellable"],
        // refundAmount: json["RefundAmount"],
        // cancellationCharges: json["cancellationCharges"],
        // gstDetails: List<GstDetail>.from(json["GSTDetails"].map((x) => GstDetail.fromJson(x))),
        // adminDetails: List<dynamic>.from(json["adminDetails"].map((x) => x)),
        // agentDetails: AgentDetails.fromJson(json["agentDetails"]),
    );

    Map<String, dynamic> toJson() => {
        // "mappingType": mappingType,
        // "totalPrice": totalPrice,
        // "couponAmount": couponAmount,
        // "commission": commission,
        // "invoiceNo": invoiceNo,
        // "postMarkup": postMarkup,
        "referenceNumber": referenceNumber,
        // "traceId": traceId,
        // "type": type,
        "bookingDate": bookingDate.toIso8601String(),
        // "Role": role,
        // "provider": provider,
        "operator": ticketAllDataOperator,
        // "returnOperator": returnOperator,
        // "tripType": tripType,
        "fareType": fareType,
        "pnr": pnr,
        // "coupanType": coupanType,
        // "UserId": userId,
        // "RoleId": roleId,
        "BookingStatus": bookingStatus,
        // "bookingStatus": ticketAllDataBookingStatus,
        // "pax": pax.toJson(),
        // "from": from,
        // "to": to,
        // "departure": departure,
        // "arrival": arrival,
        // "promoData": promoData.toJson(),
        // "convienenceData": convienenceData.toJson(),
        // "currency": currency,
        // "currencyRatio": currencyRatio,
        // "insuranceData": insuranceData,
        // "insuranceRequired": insuranceRequired,
        "journeyDate": journeyDate.toIso8601String(),
        // "operatorName": operatorName,
        // "description": description,
        // "pickUpLocation": pickUpLocation,
        // "dropLocation": dropLocation,
        // "guestName": guestName,
        // "guestEmaiId": guestEmaiId,
        // "guestMobileNo": guestMobileNo,
        // "promoId": promoId,
        "passengers": List<dynamic>.from(passengers.map((x) => x.toJson())),
        "oneWaySegment": List<dynamic>.from(oneWaySegment.map((x) => x.toJson())),
        "returnSegment": List<dynamic>.from(returnSegment.map((x) => x)),
        // "multiDestinationSegment": List<dynamic>.from(multiDestinationSegment.map((x) => x)),
        "oneWayflightFare": oneWayflightFare.toJson(),
        "returnflightFare": returnflightFare.toJson(),
        // "multicityflightFare": multicityflightFare.toJson(),
        "oneWayBaggageInfo": List<dynamic>.from(oneWayBaggageInfo.map((x) => x.toJson())),
        "returnBaggageInfo": List<dynamic>.from(returnBaggageInfo.map((x) => x)),
        // "multiDestinationBaggage": List<dynamic>.from(multiDestinationBaggage.map((x) => x)),
        "cardInfo": cardInfo.toJson(),
        // "markup": markup,
        // "BookedBy": bookedBy,
        // "AgentID": agentId,
        // "MembershipID": membershipId,
        // "cancellable": cancellable,
        // "RefundAmount": refundAmount,
        // "cancellationCharges": cancellationCharges,
        // "GSTDetails": List<dynamic>.from(gstDetails.map((x) => x.toJson())),
        // "adminDetails": List<dynamic>.from(adminDetails.map((x) => x)),
        // "agentDetails": agentDetails.toJson(),
    };
}

class AgentDetails {
    int userId;
    String firstName;
    String lastName;
    int gender;
    DateTime dob;
    String profilePic;
    String telephone;
    String city;
    String state;
    String countryId;
    String designation;
    String companyName;
    String address;
    String address1;
    String address2;
    String pan;
    String aadharCard;
    String pincode;
    String registeredIp;
    int isSiteAdminAgent;
    String email;
    String phone;
    int createdBy;
    DateTime createdDate;
    int modifiedBy;
    DateTime modifiedDate;
    String panUpload;
    String adhaarCardUpload;
    String gstUpload;
    String licenseNumber;
    String voterId;
    String passport;
    String passportUpload;
    String title;
    String comments;
    String otherDocumentsUpload;
    String paymentPreference;
    String deviceToken;
    String deviceType;
    String firBaseToken;
    dynamic deviceOs;
    dynamic deviceOsVersion;
    dynamic applicationType;
    String agencyName;
    String agentId;
    String country;
    String currency;
    dynamic isloginType;

    AgentDetails({
        required this.userId,
        required this.firstName,
        required this.lastName,
        required this.gender,
        required this.dob,
        required this.profilePic,
        required this.telephone,
        required this.city,
        required this.state,
        required this.countryId,
        required this.designation,
        required this.companyName,
        required this.address,
        required this.address1,
        required this.address2,
        required this.pan,
        required this.aadharCard,
        required this.pincode,
        required this.registeredIp,
        required this.isSiteAdminAgent,
        required this.email,
        required this.phone,
        required this.createdBy,
        required this.createdDate,
        required this.modifiedBy,
        required this.modifiedDate,
        required this.panUpload,
        required this.adhaarCardUpload,
        required this.gstUpload,
        required this.licenseNumber,
        required this.voterId,
        required this.passport,
        required this.passportUpload,
        required this.title,
        required this.comments,
        required this.otherDocumentsUpload,
        required this.paymentPreference,
        required this.deviceToken,
        required this.deviceType,
        required this.firBaseToken,
        required this.deviceOs,
        required this.deviceOsVersion,
        required this.applicationType,
        required this.agencyName,
        required this.agentId,
        required this.country,
        required this.currency,
        required this.isloginType,
    });

    factory AgentDetails.fromJson(Map<String, dynamic> json) => AgentDetails(
        userId: json["UserID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        gender: json["Gender"],
        dob: DateTime.parse(json["DOB"]),
        profilePic: json["ProfilePic"],
        telephone: json["Telephone"],
        city: json["City"],
        state: json["State"],
        countryId: json["CountryId"],
        designation: json["Designation"],
        companyName: json["CompanyName"],
        address: json["Address"],
        address1: json["Address1"],
        address2: json["Address2"],
        pan: json["PAN"],
        aadharCard: json["AadharCard"],
        pincode: json["Pincode"],
        registeredIp: json["RegisteredIP"],
        isSiteAdminAgent: json["IsSiteAdminAgent"],
        email: json["Email"],
        phone: json["Phone"],
        createdBy: json["CreatedBy"],
        createdDate: DateTime.parse(json["CreatedDate"]),
        modifiedBy: json["ModifiedBy"],
        modifiedDate: DateTime.parse(json["ModifiedDate"]),
        panUpload: json["PANUpload"],
        adhaarCardUpload: json["AdhaarCardUpload"],
        gstUpload: json["GSTUpload"],
        licenseNumber: json["LicenseNumber"],
        voterId: json["VoterId"],
        passport: json["Passport"],
        passportUpload: json["PassportUpload"],
        title: json["Title"],
        comments: json["Comments"],
        otherDocumentsUpload: json["OtherDocumentsUpload"],
        paymentPreference: json["PaymentPreference"],
        deviceToken: json["DeviceToken"],
        deviceType: json["DeviceType"],
        firBaseToken: json["FirBaseToken"],
        deviceOs: json["DeviceOS"],
        deviceOsVersion: json["DeviceOSVersion"],
        applicationType: json["ApplicationType"],
        agencyName: json["AgencyName"],
        agentId: json["AgentID"],
        country: json["Country"],
        currency: json["Currency"],
        isloginType: json["isloginType"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FirstName": firstName,
        "LastName": lastName,
        "Gender": gender,
        "DOB": dob.toIso8601String(),
        "ProfilePic": profilePic,
        "Telephone": telephone,
        "City": city,
        "State": state,
        "CountryId": countryId,
        "Designation": designation,
        "CompanyName": companyName,
        "Address": address,
        "Address1": address1,
        "Address2": address2,
        "PAN": pan,
        "AadharCard": aadharCard,
        "Pincode": pincode,
        "RegisteredIP": registeredIp,
        "IsSiteAdminAgent": isSiteAdminAgent,
        "Email": email,
        "Phone": phone,
        "CreatedBy": createdBy,
        "CreatedDate": createdDate.toIso8601String(),
        "ModifiedBy": modifiedBy,
        "ModifiedDate": modifiedDate.toIso8601String(),
        "PANUpload": panUpload,
        "AdhaarCardUpload": adhaarCardUpload,
        "GSTUpload": gstUpload,
        "LicenseNumber": licenseNumber,
        "VoterId": voterId,
        "Passport": passport,
        "PassportUpload": passportUpload,
        "Title": title,
        "Comments": comments,
        "OtherDocumentsUpload": otherDocumentsUpload,
        "PaymentPreference": paymentPreference,
        "DeviceToken": deviceToken,
        "DeviceType": deviceType,
        "FirBaseToken": firBaseToken,
        "DeviceOS": deviceOs,
        "DeviceOSVersion": deviceOsVersion,
        "ApplicationType": applicationType,
        "AgencyName": agencyName,
        "AgentID": agentId,
        "Country": country,
        "Currency": currency,
        "isloginType": isloginType,
    };
}

class CardInfo {
    CardInfo();

    factory CardInfo.fromJson(Map<String, dynamic> json) => CardInfo(
    );

    Map<String, dynamic> toJson() => {
    };
}

class GstDetail {
    int id;
    dynamic isActive;
    DateTime createdOn;
    DateTime modifiedOn;
    String orderId;
    String gstAddressLine1;
    String gstAddressLine2;
    String gstCity;
    String gstState;
    String gstpinCode;
    String gstEmailId;
    String gstNumber;
    String gstPhoneNo;
    String gstCompanyName;
    dynamic userId;

    GstDetail({
        required this.id,
        required this.isActive,
        required this.createdOn,
        required this.modifiedOn,
        required this.orderId,
        required this.gstAddressLine1,
        required this.gstAddressLine2,
        required this.gstCity,
        required this.gstState,
        required this.gstpinCode,
        required this.gstEmailId,
        required this.gstNumber,
        required this.gstPhoneNo,
        required this.gstCompanyName,
        required this.userId,
    });

    factory GstDetail.fromJson(Map<String, dynamic> json) => GstDetail(
        id: json["Id"],
        isActive: json["IsActive"],
        createdOn: DateTime.parse(json["CreatedOn"]),
        modifiedOn: DateTime.parse(json["ModifiedOn"]),
        orderId: json["OrderId"],
        gstAddressLine1: json["GSTAddressLine1"],
        gstAddressLine2: json["GSTAddressLine2"],
        gstCity: json["GSTCity"],
        gstState: json["GSTState"],
        gstpinCode: json["GSTPINCode"],
        gstEmailId: json["GSTEmailId"],
        gstNumber: json["GSTNumber"],
        gstPhoneNo: json["GSTPhoneNo"],
        gstCompanyName: json["GSTCompanyName"],
        userId: json["UserId"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "IsActive": isActive,
        "CreatedOn": createdOn.toIso8601String(),
        "ModifiedOn": modifiedOn.toIso8601String(),
        "OrderId": orderId,
        "GSTAddressLine1": gstAddressLine1,
        "GSTAddressLine2": gstAddressLine2,
        "GSTCity": gstCity,
        "GSTState": gstState,
        "GSTPINCode": gstpinCode,
        "GSTEmailId": gstEmailId,
        "GSTNumber": gstNumber,
        "GSTPhoneNo": gstPhoneNo,
        "GSTCompanyName": gstCompanyName,
        "UserId": userId,
    };
}

class YflightFare {
    int baseFare;//
    int tax;//
    int otherCharges;//
    int totalFare;//
    // int totalMealAmount;
    // int totalBaggageAmount;
    // int totalSeatAmount;
    // List<Fare>? fares;
    // int infTax;
    // int chdTax;
    // int adtTax;
    // int adtFare;
    // int chdFare;
    // int infFare;
    // String currency;
    // int adtNetFare;
    // int chdNetFare;
    // int infNetFare;

    YflightFare({
        required this.baseFare,
        required this.tax,
        required this.otherCharges,
        required this.totalFare,
        // required this.totalMealAmount,
        // required this.totalBaggageAmount,
        // required this.totalSeatAmount,
        // required this.fares,
        // required this.infTax,
        // required this.chdTax,
        // required this.adtTax,
        // required this.adtFare,
        // required this.chdFare,
        // required this.infFare,
        // required this.currency,
        // required this.adtNetFare,
        // required this.chdNetFare,
        // required this.infNetFare,
    });

    factory YflightFare.fromJson(Map<String, dynamic> json) => YflightFare(
        baseFare: json["baseFare"],
        tax: json["tax"],
        otherCharges: json["otherCharges"],
        totalFare: json["totalFare"],
        // totalMealAmount: json["totalMealAmount"],
        // totalBaggageAmount: json["totalBaggageAmount"],
        // totalSeatAmount: json["totalSeatAmount"],
        // fares: json["fares"] == null ? [] : List<Fare>.from(json["fares"]!.map((x) => Fare.fromJson(x))),
        // infTax: json["INF_Tax"],
        // chdTax: json["CHD_Tax"],
        // adtTax: json["ADT_Tax"],
        // adtFare: json["ADT_fare"],
        // chdFare: json["CHD_fare"],
        // infFare: json["INF_fare"],
        // currency: json["currency"],
        // adtNetFare: json["ADT_NET_fare"],
        // chdNetFare: json["CHD_NET_fare"],
        // infNetFare: json["INF_NET_fare"],
    );

    Map<String, dynamic> toJson() => {
        "baseFare": baseFare,
        "tax": tax,
        "otherCharges": otherCharges,
        "totalFare": totalFare,
        // "totalMealAmount": totalMealAmount,
        // "totalBaggageAmount": totalBaggageAmount,
        // "totalSeatAmount": totalSeatAmount,
        // "fares": fares == null ? [] : List<dynamic>.from(fares!.map((x) => x.toJson())),
        // "INF_Tax": infTax,
        // "CHD_Tax": chdTax,
        // "ADT_Tax": adtTax,
        // "ADT_fare": adtFare,
        // "CHD_fare": chdFare,
        // "INF_fare": infFare,
        // "currency": currency,
        // "ADT_NET_fare": adtNetFare,
        // "CHD_NET_fare": chdNetFare,
        // "INF_NET_fare": infNetFare,
    };
}

class Fare {
    int id;
    dynamic isActive;
    DateTime createdOn;
    DateTime modifiedOn;
    int fareFamilyId;
    String paxType;
    String amount;
    String fareTag;
    String fareCode;
    String fareDescription;
    dynamic userId;

    Fare({
        required this.id,
        required this.isActive,
        required this.createdOn,
        required this.modifiedOn,
        required this.fareFamilyId,
        required this.paxType,
        required this.amount,
        required this.fareTag,
        required this.fareCode,
        required this.fareDescription,
        required this.userId,
    });

    factory Fare.fromJson(Map<String, dynamic> json) => Fare(
        id: json["Id"],
        isActive: json["IsActive"],
        createdOn: DateTime.parse(json["CreatedOn"]),
        modifiedOn: DateTime.parse(json["ModifiedOn"]),
        fareFamilyId: json["FareFamilyId"],
        paxType: json["PaxType"],
        amount: json["Amount"],
        fareTag: json["FareTag"],
        fareCode: json["FareCode"],
        fareDescription: json["FareDescription"],
        userId: json["UserId"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "IsActive": isActive,
        "CreatedOn": createdOn.toIso8601String(),
        "ModifiedOn": modifiedOn.toIso8601String(),
        "FareFamilyId": fareFamilyId,
        "PaxType": paxType,
        "Amount": amount,
        "FareTag": fareTag,
        "FareCode": fareCode,
        "FareDescription": fareDescription,
        "UserId": userId,
    };
}

class OneWayBaggageInfo {
    String cityPair;
    String cabinBaggageInfo;
    String baggageInfo;

    OneWayBaggageInfo({
        required this.cityPair,
        required this.cabinBaggageInfo,
        required this.baggageInfo,
    });

    factory OneWayBaggageInfo.fromJson(Map<String, dynamic> json) => OneWayBaggageInfo(
        cityPair: json["cityPair"],
        cabinBaggageInfo: json["cabinBaggageInfo"],
        baggageInfo: json["BaggageInfo"],
    );

    Map<String, dynamic> toJson() => {
        "cityPair": cityPair,
        "cabinBaggageInfo": cabinBaggageInfo,
        "BaggageInfo": baggageInfo,
    };
}

class OneWaySegment {
    int flightSegmentId;//
    String flightNumber;//
    String airlineName;//
    // String flightCode;
    DateTime departureDateTime;
    DateTime arrivalDateTime;
    // String departureTerminal;
    // String arrivalTerminal;
    String origin;//
    String originCity;//
    String originName;//
    String destination;//
    String destinationCity;//
    String destinationName;//
    String originCountry;//
    String originCountryCode;//
    String destinationCountry;//
    String destinationCountryCode;//
    bool isReturnSegement;

    OneWaySegment({
        required this.flightSegmentId,
        required this.flightNumber,
        required this.airlineName,
        // required this.flightCode,
        required this.departureDateTime,
        required this.arrivalDateTime,
        // required this.departureTerminal,
        // required this.arrivalTerminal,
        required this.origin,
        required this.originCity,
        required this.originName,
        required this.destination,
        required this.destinationCity,
        required this.destinationName,
        required this.originCountry,
        required this.originCountryCode,
        required this.destinationCountry,
        required this.destinationCountryCode,
        required this.isReturnSegement,
    });

    factory OneWaySegment.fromJson(Map<String, dynamic> json) => OneWaySegment(
        flightSegmentId: json["flightSegmentId"],
        flightNumber: json["flightNumber"],
        airlineName: json["airlineName"],
        // flightCode: json["flightCode"],
        departureDateTime: DateTime.parse(json["departureDateTime"]),
        arrivalDateTime: DateTime.parse(json["arrivalDateTime"]),
        // departureTerminal: json["departureTerminal"],
        // arrivalTerminal: json["arrivalTerminal"],
        origin: json["origin"],
        originCity: json["originCity"],
        originName: json["originName"],
        destination: json["destination"],
        destinationCity: json["destinationCity"],
        destinationName: json["destinationName"],
        originCountry: json["originCountry"],
        originCountryCode: json["originCountryCode"],
        destinationCountry: json["destinationCountry"],
        destinationCountryCode: json["destinationCountryCode"],
        isReturnSegement: json["isReturnSegement"],
    );

    Map<String, dynamic> toJson() => {
        "flightSegmentId": flightSegmentId,
        "flightNumber": flightNumber,
        "airlineName": airlineName,
        // "flightCode": flightCode,
        "departureDateTime": departureDateTime.toIso8601String(),
        "arrivalDateTime": arrivalDateTime.toIso8601String(),
        // "departureTerminal": departureTerminal,
        // "arrivalTerminal": arrivalTerminal,
        "origin": origin,
        "originCity": originCity,
        "originName": originName,
        "destination": destination,
        "destinationCity": destinationCity,
        "destinationName": destinationName,
        "originCountry": originCountry,
        "originCountryCode": originCountryCode,
        "destinationCountry": destinationCountry,
        "destinationCountryCode": destinationCountryCode,
        "isReturnSegement": isReturnSegement,
    };
}





class Passenger {
    int passangerId;
    String title;//
    String firstName;//
    String lastName;//
    dynamic genderType;
    String email;//
    DateTime dob;//
    String areaCode;//
    // dynamic ffNumber;
    String paxType;
    String mobile;//
    // dynamic passportNumber;
    String passengerNationality;//
    // dynamic passportDoi;
    // dynamic passportDoe;
    // String passportIssuedCountry;
    // dynamic seatPref;
    // dynamic mealPref;
    // dynamic baggagePref;
    // String address;
    List<OnwaySegment> onwaySegment;
    List<OnwaySegment> returnSegment;
    List<Ticket> tickets;
    List<Ticket> returnTickets;

    Passenger({
        required this.passangerId,
        required this.title,
        required this.firstName,
        required this.lastName,
        required this.genderType,
        required this.email,
        required this.dob,
        required this.areaCode,
        // required this.ffNumber,
        required this.paxType,
        required this.mobile,
        // required this.passportNumber,
        required this.passengerNationality,
        // required this.passportDoi,
        // required this.passportDoe,
        // required this.passportIssuedCountry,
        // required this.seatPref,
        // required this.mealPref,
        // required this.baggagePref,
        // required this.address,
        required this.onwaySegment,
        required this.returnSegment,
        required this.tickets,
        required this.returnTickets,
    });

    factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        passangerId: json["passangerId"],
        title: json["title"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        genderType: json["genderType"],
        email: json["email"],
        dob: DateTime.parse(json["dob"]),
        areaCode: json["areaCode"],
        // ffNumber: json["ffNumber"],
        paxType: json["paxType"],
        mobile: json["mobile"],
        // passportNumber: json["passportNumber"],
        passengerNationality: json["passengerNationality"],
        // passportDoi: json["passportDOI"],
        // passportDoe: json["passportDOE"],
        // passportIssuedCountry: json["passportIssuedCountry"],
        // seatPref: json["seatPref"],
        // mealPref: json["mealPref"],
        // baggagePref: json["baggagePref"],
        // address: json["address"],
        onwaySegment: List<OnwaySegment>.from(json["onwaySegment"].map((x) => OnwaySegment.fromJson(x))),
        returnSegment: List<OnwaySegment>.from(json["returnSegment"].map((x) => OnwaySegment.fromJson(x))),
        tickets: List<Ticket>.from(json["tickets"].map((x) => Ticket.fromJson(x))),
        returnTickets: List<Ticket>.from(json["returnTickets"].map((x) => Ticket.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "passangerId": passangerId,
        "title": title,
        "firstName": firstName,
        "lastName": lastName,
        "genderType": genderType,
        "email": email,
        "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "areaCode": areaCode,
        // "ffNumber": ffNumber,
        "paxType": paxType,
        "mobile": mobile,
        // "passportNumber": passportNumber,
        "passengerNationality": passengerNationality,
        // "passportDOI": passportDoi,
        // "passportDOE": passportDoe,
        // "passportIssuedCountry": passportIssuedCountry,
        // "seatPref": seatPref,
        // "mealPref": mealPref,
        // "baggagePref": baggagePref,
        // "address": address,
        "onwaySegment": List<dynamic>.from(onwaySegment.map((x) => x.toJson())),
        "returnSegment": List<dynamic>.from(returnSegment.map((x) => x.toJson())),
        "tickets": List<dynamic>.from(tickets.map((x) => x.toJson())),
        "returnTickets": List<dynamic>.from(returnTickets.map((x) => x.toJson())),
    };
}

class OnwaySegment {
    int flightSegmentId;
    String flightId;
    String name;

    OnwaySegment({
        required this.flightSegmentId,
        required this.flightId,
        required this.name,
    });

    factory OnwaySegment.fromJson(Map<String, dynamic> json) => OnwaySegment(
        flightSegmentId: json["flightSegmentId"],
        flightId: json["flightId"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "flightSegmentId": flightSegmentId,
        "flightId": flightId,
        "name": name,
    };
}

class Ticket {
    String ticketNumber;
    String sourceTicketType;
    String supplierParameter;
    String firstName;
    String lastName;
    String paxType;

    Ticket({
        required this.ticketNumber,
        required this.sourceTicketType,
        required this.supplierParameter,
        required this.firstName,
        required this.lastName,
        required this.paxType,
    });

    factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        ticketNumber: json["ticketNumber"],
        sourceTicketType: json["sourceTicketType"],
        supplierParameter: json["supplierParameter"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        paxType: json["paxType"],
    );

    Map<String, dynamic> toJson() => {
        "ticketNumber": ticketNumber,
        "sourceTicketType": sourceTicketType,
        "supplierParameter": supplierParameter,
        "firstName": firstName,
        "lastName": lastName,
        "paxType": paxType,
    };
}

class Pax {
    int adults;
    int childCount;
    int infantCount;

    Pax({
        required this.adults,
        required this.childCount,
        required this.infantCount,
    });

    factory Pax.fromJson(Map<String, dynamic> json) => Pax(
        adults: json["adults"],
        childCount: json["childCount"],
        infantCount: json["infantCount"],
    );

    Map<String, dynamic> toJson() => {
        "adults": adults,
        "childCount": childCount,
        "infantCount": infantCount,
    };
}
