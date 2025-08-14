# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the project file and restore dependencies
COPY dockerLab/dockerLab/dockerLab.csproj ./dockerLab/
RUN dotnet restore dockerLab/dockerLab.csproj

# Copy all source files
COPY dockerLab/ ./dockerLab/

# Build the project explicitly
RUN dotnet build dockerLab/dockerLab/dockerLab.csproj -c Release

# Publish the app
RUN dotnet publish dockerLab/dockerLab/dockerLab.csproj -c Release -o /app/publish --no-self-contained

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "dockerLab.dll"]
