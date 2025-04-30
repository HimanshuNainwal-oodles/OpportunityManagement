public class WeeklyOpportunitySummaryScheduler implements Schedulable{
    public void execute(SchedulableContext sc) {
        WeeklyOpportunitySummarySender.sendSummaryEmails();
    }
}