using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Wcenzije.API.Migrations
{
    public partial class Roles : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string[]>(
                name: "UserRoles",
                table: "AspNetUsers",
                type: "text[]",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "UserRoles",
                table: "AspNetUsers");
        }
    }
}
