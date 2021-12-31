FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

RUN apt-get update \
  && apt-get install -y \
    dos2unix


WORKDIR /build

COPY SS14.Watchdog/ .

RUN dotnet restore

RUN dotnet publish -c Release -r linux-x64 --no-self-contained

RUN cp -R bin/Release/net6.0/linux-x64/publish /app
RUN cp appsettings.Development.yml /app/appsettings.yml

COPY ian.sh ian.sh
RUN dos2unix ian.sh


FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS app

COPY --from=build /app /app
COPY --from=build /build/ian.sh ian.sh

EXPOSE 1212/tcp
EXPOSE 1212/udp

VOLUME ["/app/instances", "/app_config"]

ENTRYPOINT ["./ian.sh"]