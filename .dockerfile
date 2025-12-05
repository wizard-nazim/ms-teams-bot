# Stage 1: build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# copy csproj + restore + copy rest + publish
COPY . .  
RUN dotnet restore  
RUN dotnet publish -c Release -o out

# Stage 2: run
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Make app listen to whatever port Render assigns via $PORT
ENV ASPNETCORE_URLS=http://+:${PORT}  
COPY --from=build /app/out .  

EXPOSE ${PORT}

# Replace 'YourBotProject.dll' with your actual DLL name from publish output
ENTRYPOINT ["dotnet", "bot-wizard.dll"]
