# Get base SDK image from Microsoft
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy the CSPROJ file and restore any dependancies (via NUGET)
COPY *.csproj ./
RUN dotnet restore

# Copy the project files and build our release
COPY . ./
RUN dotnet publish -c Release -o out

# Generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
# FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /app
EXPOSE 5000
COPY --from=build-env /app/out .
ENTRYPOINT [ "dotnet", "MyDockerTest1.dll", "urls=http://*:5000" ]