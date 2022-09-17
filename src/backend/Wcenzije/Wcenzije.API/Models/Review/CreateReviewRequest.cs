using System.ComponentModel.DataAnnotations;
using Wcenzije.API.Entities;
using Wcenzije.API.Enums;

namespace Wcenzije.API.Models.Review
{
    public class CreateReviewRequest
    {
        [Required] public string Content { get; set; }
        [Required] public string Name { get; set; }
        [Required] public string Location { get; set; }
        [Required] public Gender Gender { get; set; }
        [Required] public int Rating { get; set; }

        public List<string>? ImageUrls { get; set; }
        public int LikeCount { get; set; }
        public Qualities? Qualities { get; set; }
    }
}
