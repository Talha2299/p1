#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
#COPY ["PartnerPortal.csproj", "/"
COPY . .
#RUN ls
#RUN dotnet nuget add source "https://pkgs.dev.azure.com/rmscloud/RMS/_packaging/RMS/nuget/v3/index.json" --name "RMS" --username "mwu@rms.com.au" --password "ajh3gzzi7h5qpaxmkrf3gfom6pm4rerbbollorullgrvndpt2ogq" --store-password-in-clear-text
RUN dotnet restore "PartnerPortal.csproj" --configfile "./nuget.config"
#COPY . .
#COPY Libs Libs
#WORKDIR "/src/PartnerPortalCore"
#RUN ls
RUN dotnet build "PartnerPortal.csproj" -c Release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "PartnerPortal.csproj" -c Release -o /app/publish --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
#SQL Session table tool
#RUN dotnet tool install --global dotnet-sql-cache

ENTRYPOINT ["dotnet", "PartnerPortal.dll"]
