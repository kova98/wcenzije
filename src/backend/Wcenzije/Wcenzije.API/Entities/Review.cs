using Wcenzije.API.Enums;

namespace Wcenzije.API.Entities
{
    public class Review
    {
        public long Id { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateUpdated { get; set; }
        public List<string> ImageUrls { get; set; }
        public string Content { get; set; }
        public string Name { get; set; }
        public string Location { get; set; }
        public int LikeCount { get; set; }
        public int Rating { get; set; }
        public Qualities? Qualities { get; set; }
        public Gender Gender { get; set; }
    }
}
