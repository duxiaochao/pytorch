if "%BUILD_ENVIRONMENT%"=="" (
  set CONDA_PARENT_DIR=%CD%
) else (
  set CONDA_PARENT_DIR=C:\Jenkins
)
if "%REBUILD%"=="" (
  IF EXIST %CONDA_PARENT_DIR%\Miniconda3 ( rd /s /q %CONDA_PARENT_DIR%\Miniconda3 )
  curl --retry 3 -k https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe --output %TMP_DIR_WIN%\Miniconda3-latest-Windows-x86_64.exe
  %TMP_DIR_WIN%\Miniconda3-latest-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /S /AddToPath=0 /D=%CONDA_PARENT_DIR%\Miniconda3
)
call %CONDA_PARENT_DIR%\Miniconda3\Scripts\activate.bat %CONDA_PARENT_DIR%\Miniconda3
if "%REBUILD%"=="" (
  :: We have to pin Python version to 3.6.7, until mkl supports Python 3.7
  call conda install -y -q python=3.6.7 numpy cffi pyyaml boto3
)
curl --retry 3 -kL https://www.dropbox.com/s/blbxffkpee3rtlb/python-debug-libs.7z?dl=1 --output %TMP_DIR_WIN%\python-debug-libs.7z
7z x %TMP_DIR_WIN%\python-debug-libs.7z -o%TMP_DIR_WIN%\python_debug_libs
set LIB=%TMP_DIR_WIN%\python_debug_libs;%LIB%
