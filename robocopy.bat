REM --- Script para execucao de copia de arquivos através do robocopy ---

@echo off
setlocal EnableExtensions

REM --- Origens/Destinos ---
set "SRC=E:\Benner\WES\RH"
set "DST=\\oci-wes-rh01\E$\BENNER\WES\CASF\RH"

REM --- Pasta de logs ao lado do script ---
set "LOGDIR=%~dp0logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

REM --- Timestamp seguro para nome do arquivo (aaaa-mm-dd_hh-mm-ss) ---
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "STAMP=%%I"
set "LOG=%LOGDIR%\robocopy_RH_%STAMP%.log"

echo Iniciando robocopy em %date% %time%
echo Origem:      "%SRC%"
echo Destino:     "%DST%"
echo Log em:      "%LOG%"
echo.

REM --- Copia mantendo subpastas (/E), 1 tentativa (/R:1), 1s de espera (/W:1), 10 threads (/MT:10)
REM --- /TEE = mostra na tela e grava no log; /LOG = arquivo de log
robocopy "%SRC%" "%DST%" /E /R:1 /W:1 /MT:10 /TEE /LOG:"%LOG%"
set "RC=%ERRORLEVEL%"

echo.
echo Log salvo em: "%LOG%"

REM Robocopy: 0-7 = sucesso (com/sem cópias); >=8 = falha
if %RC% GEQ 8 (
  echo Robocopy terminou com ERROS. Codigo: %RC%
  exit /b %RC%
) else (
  echo Robocopy concluido com SUCESSO. Codigo: %RC%
  exit /b 0
)

