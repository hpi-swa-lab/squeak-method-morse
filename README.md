# MethodMorse

> Automatically sync changes between multiple Squeak images

## Installation

1. [Get a recent Squeak Trunk image](https://squeak.org/downloads/)

2. Do the following:

   ```smalltalk
   Metacello new
   	baseline: 'MethodMorse';
   	repository: 'github://hpi-swa-lab/squeak-method-morse:main';
   	get; "for updates"
   	load.
   ```

3. Open MethodMorse from the Apps menu.
