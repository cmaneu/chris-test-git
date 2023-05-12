FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Copy everything

# Restore as distinct layers
COPY ["app/chris-test-git.csproj", "."]
RUN dotnet restore "chris-test-git.csproj"

COPY app/ ./
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/nightly/aspnet:7.0-jammy-chiseled
WORKDIR /
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "chris-test-git.dll"]