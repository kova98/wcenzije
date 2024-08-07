﻿using Microsoft.EntityFrameworkCore;
using Wcenzije.Domain.Entities;
using Wcenzije.Domain.Models;
using Wcenzije.Domain.Repositories;

namespace Wcenzije.Persistence.Repositories
{
    public class ReviewsRepository : IReviewsRepository
    {
        private readonly AppDbContext _context;

        public ReviewsRepository(AppDbContext context)
        {
            _context = context;
        }

        public void CreateReview(Review review)
        {
            review.Id = 0;
            _context.Reviews.Add(review);
            _context.SaveChanges();
        }

        public void DeleteReview(long id)
        {
            _context.Remove(_context.Reviews.First(x => x.Id == id));
            _context.SaveChanges();
        }

        public Review? GetReview(long id)
        {
            return _context.Reviews
                .Where(x => x.Id == id)
                .Include(x=>x.Qualities)
                .FirstOrDefault();    
        }

        public List<Review> GetAllReviews()
        {
            return _context.Reviews
                .Include(x => x.Qualities)
                .OrderByDescending(x=>x.DateCreated)
                .ToList();
        }

        public List<Review> GetReviewsByAuthor(string author)
        {
            return _context.Reviews
                .Include(x => x.Qualities)
                .Where(x => x.Author == author)
                .ToList();
        }
        
        public void DeleteUserReviews(string username)
        {
            var reviews = _context.Reviews.Where(x => x.Author == username);
            _context.Reviews.RemoveRange(reviews);
            _context.SaveChanges();
        }
        
        public List<SimpleReview> GetAllReviewsSimple()
        {
            return _context.Reviews
                .Select(x => new SimpleReview
                {
                    Id = x.Id,
                    Name = x.Name,
                    Location = x.Location,
                })
                .ToList();
        }
        
        public PagedResult<Review> GetReviews(int page = 1, int pageSize = 10, List<long>? reviewIds = null)
        {
            var query = _context.Reviews
                .Include(x => x.Qualities)
                .OrderByDescending(x => x.DateCreated)
                .AsQueryable();

            if (reviewIds != null && reviewIds.Count != 0)
            {
                query = query.Where(x => reviewIds.Contains(x.Id));
            }

            var data = query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();
            
            return new PagedResult<Review>
            {
                Data = data,
                Page = page,
                PageSize = pageSize,
                TotalCount = query.Count()
            };
        }
        
        public void UpdateReview(Review review)
        {
            var reviewToUpdate = _context.Reviews.Find(review.Id);
            reviewToUpdate.ImageUrls = review.ImageUrls;
            reviewToUpdate.Content = review.Content;
            reviewToUpdate.LikeCount = review.LikeCount;
            reviewToUpdate.Name = review.Name;
            reviewToUpdate.Location = review.Location;
            reviewToUpdate.Rating = review.Rating;

            _context.SaveChanges();
        }
    }
}
