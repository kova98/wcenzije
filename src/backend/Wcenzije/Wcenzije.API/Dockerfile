
# Build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src/Wcenzije.API
COPY ["Wcenzije.API.csproj", "."]
RUN dotnet restore "Wcenzije.API.csproj"
COPY . .
WORKDIR "/src/Wcenzije.API"
RUN dotnet build "Wcenzije.API.csproj" -c Release -o /app/build

# Publish
FROM build AS publish
RUN dotnet publish "Wcenzije.API.csproj" -c Release -o /app/publish

# Run
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=publish /app/publish .
# Using $PORT to bind to the Heroku port
CMD ASPNETCORE_URLS=http://*:$PORT dotnet Wcenzije.API.