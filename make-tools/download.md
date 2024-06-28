Sure! Here’s a `README.md` file to explain how to use the Makefile script:

# Makefile for Downloading and Verifying Files

This Makefile script automates the process of downloading files from a repository server and verifying their integrity using checksums. It supports both `curl` and `wget` for downloading files.

## Variables

- `REPO_SERVER`: The URL of the repository server (default: `https://reposerver.com`).
- `FILE_PATH`: The path to the folder containing the files on the repository server (default: `Folder/Sub-folder`).
- `FILE_NAMES`: The names of the files to download (default: `file1.tgz file2.tar.gz`).
- `REPO_USER`: The username for authentication (optional).
- `REPO_PASS`: The password for authentication (optional).

## Targets

- `download-curl`: Downloads files using `curl` and verifies their checksums.
- `download-wget`: Downloads files using `wget` and verifies their checksums.
- `checksum-verification`: Verifies the checksum of a downloaded file.

## Usage

### Downloading Files with `curl`

To download the files using `curl`, run:

```sh
make download-curl
```

### Downloading Files with `wget`

To download the files using `wget`, run:

```sh
make download-wget
```

### Customizing Variables

You can customize the variables by setting them in the command line. For example, to change the repository server and file path, run:

```sh
make download-curl REPO_SERVER=https://newreposerver.com FILE_PATH=NewFolder/Sub-folder
```

### Authentication

If the repository server requires authentication, set the `REPO_USER` and `REPO_PASS` variables:

```sh
make download-curl REPO_USER=username REPO_PASS=password
```

## How It Works

1. The `download-curl` and `download-wget` targets iterate over the list of `FILE_NAMES`.
2. For each file, it downloads the file using `curl` or `wget` and then calls the `checksum-verification` target.
3. The `checksum-verification` target fetches the remote checksum for the file and compares it with the checksum of the downloaded file.
4. If the checksums do not match, an error message is displayed, and the script exits with a failure status.

## Example

To download files from `https://example.com/files` with the username `user` and password `pass`, and verify their checksums, use:

```sh
make download-curl REPO_SERVER=https://example.com FILE_PATH=files REPO_USER=user REPO_PASS=pass
```

## Notes

- Ensure that the repository server provides the checksum files in the same directory as the target files, with a `.sha256` extension.
- Modify the checksum URL pattern in the Makefile if your setup differs.

## License

This project is licensed under the MIT License.
