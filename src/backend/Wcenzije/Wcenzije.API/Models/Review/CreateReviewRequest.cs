using System.ComponentModel.DataAnnotations;
using Wcenzije.Domain.Entities;
using Wcenzije.Domain.Enums;

namespace Wcenzije.API.Models.Review
{
    public class CreateReviewRequest
    {
        [Required] public string Content { get; set; }
        [Required] public string Name { get; set; }
        [Required] public string Location { get; set; }
        [Required] public Gender Gender { get; set; }
        [Required] public int Rating { get; set; }

        public bool IsAnonymous { get; set; } = false;
        public List<string> ImageUrls { get; set; }
        public int LikeCount { get; set; }
        public Qualities Qualities { get; set; }
    }
}
