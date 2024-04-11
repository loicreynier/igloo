# SkyrimSE Mod

1. Setup environment by defining MO2 path

   ```shell
   cp .env.example .env
   vi .env
   ```

2. Import mod plugins using `just serialize $MO2_MODS/<mod>`

3. Write a `data/fomod/{index.xml,moduleconfig.xml}` and validate it using `fomod-validator data`

4. Write a `description.md`
