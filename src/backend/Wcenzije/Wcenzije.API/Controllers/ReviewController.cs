using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Wcenzije.API.Models.Review;
using Wcenzije.Domain.Entities;
using Wcenzije.Domain.Repositories;
using Wcenzije.Domain.Services;

namespace Wcenzije.API.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class ReviewController : ControllerBase
    {
        private readonly IReviewsRepository _reviewsRepo;
        private readonly IImageUploadService _imageUploadService;

        public ReviewController(IReviewsRepository reviewsRepo, IImageUploadService imageUploadService)
        {
            _reviewsRepo = reviewsRepo;
            _imageUploadService = imageUploadService;
        }

        [AllowAnonymous]
        [HttpGet]
        public IActionResult GetReviews()
        {
            var reviews = _reviewsRepo
                .GetAllReviews()
                .Where(LocationIsValid);

            foreach (var review in reviews)
            {
                if (review.IsAnonymous)
                {
                    review.Author = null;
                }
            }

            return Ok(reviews);
        }

        [HttpGet("author/{author}")]
        public IActionResult GetReviewsByAuthor(string author)
        {
            var reviews = _reviewsRepo.GetReviewsByAuthor(author);
            return Ok(reviews);
        }

        [AllowAnonymous]
        [HttpGet("{id}", Name = nameof(GetReview))]
        public IActionResult GetReview(long id)
        {
            var review = _reviewsRepo.GetReview(id);
            if (review == null)
            {
                return NotFound();
            }
            
            if (review.IsAnonymous)
            {
                review.Author = null;
            }
            
            return Ok(review);
        }

        [HttpPost]
        public IActionResult CreateReview(CreateReviewRequest request)
        {
            var review = new Review
            {
                Name = request.Name,
                Content = request.Content,
                Gender = request.Gender,
                Location = request.Location,
                Qualities = request.Qualities,
                LikeCount = request.LikeCount,
                Rating = request.Rating,
                ImageUrls = request.ImageUrls ?? new(),
                DateCreated = DateTime.UtcNow,
                Author = User.Identity.Name,
                IsAnonymous = request.IsAnonymous
            };

            _reviewsRepo.CreateReview(review);

            return CreatedAtAction(nameof(GetReview), new { Id = review.Id}, review);
        }

        [HttpPost("{id}/images")]
        [DisableRequestSizeLimit]
        public async Task<IActionResult> AddImagesToReview(long id, [FromForm]List<IFormFile> files)
        {
            var review = _reviewsRepo.GetReview(id);

            if (review == null) return NotFound();

            if (review.Author != User.Identity.Name)
            {
                return Unauthorized();
            }

            review.ImageUrls = await _imageUploadService.Upload(files);

            _reviewsRepo.UpdateReview(review);

            return Ok();
        }

        [HttpPut]
        public IActionResult EditReview(Review review)
        {
            var reviewToUpdate = _reviewsRepo.GetReview(review.Id);

            if (reviewToUpdate == null) return NotFound();

            if (reviewToUpdate.Author != User.Identity.Name)
            {
                return Unauthorized();
            }

            review.DateUpdated = DateTime.UtcNow;
            _reviewsRepo.UpdateReview(review);

            return Ok(reviewToUpdate);
        }


        [HttpDelete("{id}")]
        public IActionResult DeleteReview(long id)
        {
            var review = _reviewsRepo.GetReview(id);

            if (review == null) return NotFound();

            if (review.Author != User.Identity.Name)
            {
                return Unauthorized();
            }

            _reviewsRepo.DeleteReview(id);

            return Ok();
        }

        private bool LocationIsValid(Review arg)
        {
            if (string.IsNullOrEmpty(arg.Location)) return false;   

            var locationStrings = arg.Location.Split(',');

            if (locationStrings.Length != 2) return false;
            
            var latValid = double.TryParse(locationStrings[0], out _);
            var lngValid = double.TryParse(locationStrings[1], out _);

            return latValid && lngValid;
        }
    }
}
