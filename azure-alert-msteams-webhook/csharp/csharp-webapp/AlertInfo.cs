namespace csharp_webapp
{
    public class AlertInfo
    {
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public DateTime AlertStartTime { get; set; }
        public DateTime AlertEndTime { get; set; }
        public int CountOfAlerts { get; set; }
        public string TeamsWebHookEndPoint { get; set; } = string.Empty;
        public string AppInsightLink { get; set; } = string.Empty;
        public Dictionary<string,string> ContextProperties { get; set; } = new Dictionary<string,string>();
    }
}
