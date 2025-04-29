# Utilizar la imagen base de .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app
COPY src/. ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Imagen de runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runtime
LABEL org.opencontainers.image.source="https://github.com/p-cuadros/Shorten02"

WORKDIR /app
ENV ASPNETCORE_URLS=http://+:80
RUN apk add icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
COPY --from=build /app/out .

EXPOSE 80

ENTRYPOINT ["dotnet", "Shorten.dll"]
