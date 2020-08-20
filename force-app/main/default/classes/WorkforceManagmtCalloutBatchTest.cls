/**
 * @description       : Class to test the WorkforceManagmtCalloutBatch for callout
 * @author            : Shalini Tripathi
 * @last modified on  : 08-20-2020
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   08-20-2020   Shalini Tripathi                    Initial Version
 **/
@isTest
public class WorkforceManagmtCalloutBatchTest {
/**
 * @description : Method to create the case test data
 **/
@TestSetup
public static void createData(){
	List<Case> caseList = new List<Case>();
	for(Integer i=1; i<=100; i++) {
		Case caseRec = new Case();
		caseRec.Status = 'New';
		caseRec.Origin = 'Phone';
		caseRec.WorkForceStatus__c = 'Pending';
		caseList.add(caseRec);
	}
	insert caseList;

	for(Case caseRec:caseList) {
		caseRec.Status = 'Closed';
	}
	update caseList;
}
/**
 * @description : Method to test when the workforce callout failed
 **/
@IsTest
public static void testCalloutFailure(){

	Test.setMock(HttpCalloutMock.class, new WorkforceManagmtCalloutBatchMock('Failure',500,''));
	Test.startTest();
	WorkforceManagmtCalloutBatch callBatch = new WorkforceManagmtCalloutBatch();
	database.executebatch(callBatch,100);
	Test.stopTest();
	Case caseRec = [SELECT Id,Status,WorkForceStatus__c,SecretKey__c
	                FROM Case
	                LIMIT 1];
	// check record were saved with status as failed as API returned error
	System.assertEquals('Failed', caseRec.WorkForceStatus__c);
	//Integration status updated successfully 
	System.assertEquals(100,[SELECT Id FROM Case WHERE WorkForceStatus__c='Failed'].size());
}
/**
 * @description : Method to test when the workforce callout passed
 **/
@IsTest
public static void testCalloutSuccess(){

	Test.setMock(HttpCalloutMock.class, new WorkforceManagmtCalloutBatchMock('OK',200,'{"success":true,"secretKey":"12345"}'));
	Test.startTest();
	WorkforceManagmtCalloutBatch callBatch = new WorkforceManagmtCalloutBatch();
	database.executebatch(callBatch,100);
	Test.stopTest();
	Case caseRec = [SELECT Id,Status,WorkForceStatus__c,SecretKey__c
	                FROM Case
	                LIMIT 1];
	//records marked success
	System.assertEquals('Sent', caseRec.WorkForceStatus__c);
	//secret key was updated succesfully
	System.assertEquals('12345', caseRec.SecretKey__c);
	//Integration status updated successfully 
	System.assertEquals(100,[SELECT Id FROM Case WHERE WorkForceStatus__c='Sent'].size());
}
}