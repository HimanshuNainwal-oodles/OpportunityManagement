public class WeeklyOpportunitySummaryScheduler implements Schedulable{
    void execute(SchedulableContext sc) {
        WeeklyOpportunitySummarySender.sendSummaryEmails();
    }
}