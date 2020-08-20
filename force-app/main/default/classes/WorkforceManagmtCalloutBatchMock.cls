/**
 * @description       : Class used to send callout mock for WorkforceManagmtCalloutBatchTest
 * @author            : Shalini Tripathi
 * @last modified on  : 08-20-2020
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   08-20-2020   Shalini Tripathi                    Initial Version
 **/
@isTest
public class WorkforceManagmtCalloutBatchMock implements HttpCalloutMock {
String status;
Integer code;
String body;
/**
 * @description : Constructor to initialize the value for success or failure
 **/
public WorkforceManagmtCalloutBatchMock(String status,Integer code, String body){
	this.status = status;
	this.code = code;
	this.body = body;
}
/**
 * @description : Method to send the fake response for success and failure
 **/
public HTTPResponse respond(HTTPRequest request){
	HttpResponse response = new HttpResponse();
	response.setHeader('Content-Type', 'application/json');
	response.setStatus(status);
	response.setStatusCode(code);
	response.setBody(body);
	return response;
}
}