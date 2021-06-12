@echo off
cd file
if exist %~dp0\file\node_modules (
  node index.js 
) else (
  echo Open first the installation!
  pause
)