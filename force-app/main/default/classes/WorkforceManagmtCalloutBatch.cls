/**
 * @description       : callout for WorkforceManagmtCalloutBatchTest
 * @author            : Shalini Tripathi
 * @last modified on  : 08-20-2020
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   08-20-2020   Shalini Tripathi                    Initial Version
 **/
global class WorkforceManagmtCalloutBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
public String soqlQuery;
/**
 * @description : Wrapper class for Sending and Receiving the JSON
 **/
class JSONWrapper {
public Boolean success {get; set;}
public String secretKey {get; set;}
public String id {get; set;}
public String agentid {get; set;}
public JSONWrapper() {
}
public JSONWrapper(String id,String agentid){
	this.id=id;
	this.agentid = agentid;
}
}

/**
 * @description : Method to get all the input record for the batch class
 * @param bc
 **/
global Database.QueryLocator start(Database.BatchableContext bc){
	string sQuery= soqlQuery==null
	               ? 'SELECT Id, secretKey__c, LastModifiedById,WorkForceStatus__c From Case WHERE WorkForceStatus__c in(\'Pending\',\'Failed\') AND Status=\'Closed\''
	               : soqlQuery;
	return Database.getQueryLocator(sQuery);
}
/**
 * @description : Method to do the callout to workforce and provide the case info and process the result from callout
 * @param  List of case to update workforce
 **/
global void execute(Database.BatchableContext bc, List<case> caseToUpdate){
	try{
		for(Case eachClosedCase: caseToUpdate) {
			JSONWrapper calloutJSON =new JSONWrapper(eachClosedCase.Id,
			                                         eachClosedCase.LastModifiedById);
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint('callout:workforce_management');
			request.setMethod('POST');
			request.setTimeout(Integer.valueof(System.Label.Workforce_Timeout));
			request.setHeader('Content-Type', 'application/json;charset=utf-8');
			request.setBody(JSON.serialize(calloutJSON));
			HttpResponse response = http.send(request);
			if (response.getStatusCode()==200) {
				JSONWrapper responseJSON=new JSONWrapper();
				responseJSON= (JSONWrapper)JSON.deserialize(response.getBody(),JSONWrapper.class);
				eachClosedCase.secretKey__c = responseJSON.secretKey;
				eachClosedCase.WorkForceStatus__c='Sent';
			}
			if (response.getStatusCode()==500) {
				eachClosedCase.WorkForceStatus__c='Failed';
			}
		}
		// Partial update to case
		database.update(caseToUpdate,false);
	}
	catch(Exception e) {
		//TODO add exception handling and use log object records
		System.debug('Error-' + e.getMessage());
	}
}
global void finish(Database.BatchableContext BC){
}
}