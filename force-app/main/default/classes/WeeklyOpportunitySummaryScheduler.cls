public class WeeklyOpportunitySummaryScheduler implements Schedulable{
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new WeeklyOpportunitySummarySender(), 9);
       // WeeklyOpportunitySummarySender.sendSummaryEmails();
    }
}