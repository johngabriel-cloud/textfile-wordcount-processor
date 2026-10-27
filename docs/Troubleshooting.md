**# Troubleshooting**

1. **ERROR: Started the project by writing standalone Python files without initializing a project.**
   - Reproduction: Start writing Python modules and tests without creating a project structure or configuring dependencies.
   - Solution: Since I'm using `uv` as the project manager, I initialized the project with `uv init`.

2. **ERROR: `ModuleNotFoundError` after moving Python modules into their designated folders.**
   - Reproduction:
     - Place `wordcount.py` inside the `textfile_wordcount_processor` package and `test_wordcount.py` inside `tests/`.
     - Run pytest while the test still imports `from wordcount import count_words`.
   - Solution: Changed the import to `from textfile_wordcount_processor.wordcount import count_words` so it matches the package structure.

3. **ERROR: `botocore.exceptions.NoRegionError: You must specify a region.` during handler tests.**
   - Reproduction:
     - Run `uv run pytest tests/test_handler.py -v` without configuring an AWS region in the test environment.
     - The test fails when the handler initializes a Boto3 client and no region is available.
   - Solution: Set `os.environ["AWS_DEFAULT_REGION"] = "us-east-1"` in the test configuration as a placeholder region. This allows local tests to initialize the client without deploying resources.

4. **ERROR: `Failed to query available provider packages` during `terraform init`.**
   - Reproduction:
     - Run `terraform init` from the `terraform/` directory.
     - Terraform fails while retrieving provider information from the Terraform Registry.
   - Solution:
     - Run `terraform providers` to inspect the required provider configuration.
     - Check connectivity to `https://registry.terraform.io/.well-known/terraform.json`.
     - Retry initialization if the failure is caused by a temporary network timeout.

5. **ERROR: GitHub rejects `git push` because the Terraform AWS provider binary exceeds the 100 MB file limit.**
   - Reproduction:
     - Run `terraform init` to download the AWS provider into `terraform/.terraform/`.
     - Run `git add .` when the provider directory is not being ignored, or before the ignore rule takes effect.
     - Commit the files and run `git push origin main`.
     - GitHub rejects the push because `terraform-provider-aws_v6.70.0_x5` is approximately 794 MB.
   - Solution:
     - Add `.terraform/` to `.gitignore` to prevent untracked Terraform working files from being staged.
     - Run `git ls-files terraform/.terraform/` to check whether the provider files are already tracked.
     - Run `git rm -r --cached terraform/.terraform/` to remove the directory from Git's index without deleting local files.
     - If the oversized binary exists in commits being pushed, install `git-filter-repo` and run `git filter-repo --force --path terraform/.terraform/ --invert-paths` to remove it from the relevant Git history.
     - Restore the GitHub remote if the history cleanup removes it:
       `git remote add origin https://github.com/johngabriel-cloud/textfile-wordcount-processor.git`
     - Run `git fetch origin` and verify the cleaned history before pushing again.
     - Run `git push origin main`. The push succeeded after the oversized binary was removed from the unpushed history.
   - Lesson learned: `.gitignore` does not automatically untrack files already staged or committed. Ignore Terraform's `.terraform/` directory and state files, but keep `.terraform.lock.hcl` tracked.