## Configure the Terminfo

  1. Verify Smulx in Tmux
  ```shell
   infocmp -l -x | grep Smulx
   ```
  2. Generate a Terminfo File
  ```shell
   infocmp > /tmp/${TERM}.ti
  ```
  3. Edit the Terminfo File
  ```Shell
   nvim /tmp/${TERM}.ti
  ```
  Add the following line after `smul=\E[4m,`: `Smulx=\E[4:%p1%dm,`

  4. Reload the Terminfo
  ```Shell
   tic -x /tmp/${TERM}.ti
  ```

