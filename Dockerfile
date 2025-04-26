# Utilizar la imagen base de .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el resto de la aplicación y compilar
COPY src/. ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Utilizar la imagen base de .NET Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runtime
LABEL org.opencontainers.image.source="https://github.com/p-cuadros/Shorten02"

# Establecer el directorio de trabajo
WORKDIR /app

# Expone el puerto 80 para que Azure pueda enlazarlo
EXPOSE 80

# Configurar la URL base
ENV ASPNETCORE_URLS=http://+:80

# Para soporte de globalización
RUN apk add icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Copiar los archivos compilados desde la etapa de construcción
COPY --from=build /app/out .

# Definir el comando de entrada para ejecutar la aplicación
ENTRYPOINT ["dotnet", "Shorten.dll"]
