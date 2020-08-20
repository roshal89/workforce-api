/**
* @description       : Test class for WorkforceManagmtCalloutSchedule
* @author            : Shalini Tripathi  
* @last modified on  : 08-20-2020
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   08-20-2020   Shalini Tripathi                   Initial Version
**/
@istest
public class WorkforceManagmtCalloutScheduleTest {
    /**
* @description : Method to test the WorkforceManagmtCalloutSchedule schedule
**/
    @istest
    public static void testschedule() {
        Test.StartTest();
        WorkforceManagmtCalloutSchedule sh = new WorkforceManagmtCalloutSchedule();
        //Execute the job daily at 10 PM
        String cron = '0 0 22 * * ? *';
        system.schedule('Schedule for Workforce', cron, sh);
        Test.stopTest();
        // Check schedulable is in the job list
        List<AsyncApexJob> jobsScheduled = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'ScheduledApex'];
        System.assertEquals(1, jobsScheduled.size(), 'expecting scheduled job');
        System.assertEquals('WorkforceManagmtCalloutSchedule', jobsScheduled[0].ApexClass.Name, 'expecting specific job');
    }
}