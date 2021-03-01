FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
#COPY ["PartnerPortal.csproj", "/"
COPY . .
#RUN ls
RUN dotnet nuget add source "https://pkgs.dev.azure.com/rmscloud/RMS/_packaging/RMS/nuget/v3/index.json" --name "RMS" --username "mwu@rms.com.au" --password "ajh3gzzi7h5qpaxmkrf3gfom6pm4rerbbollorullgrvndpt2ogq" --store-password-in-clear-text
RUN dotnet restore "PartnerPortal.csproj"
#COPY . .
#COPY Libs Libs
#WORKDIR "/src/PartnerPortalCore"
#RUN ls
RUN dotnet build "PartnerPortal.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PartnerPortal.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
#SQL Session table tool
#RUN dotnet tool install --global dotnet-sql-cache

ENTRYPOINT ["dotnet", "PartnerPortal.dll"]
