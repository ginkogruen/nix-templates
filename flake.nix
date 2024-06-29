{
  description = "ginkogruen's flake templates";

  outputs = { self, ... }: {
    templates = {
      supercollider = {
        path = ./supercollider;
	description = "A simple SuperCollider project";
      };
      r-studio = {
        path = ./rstudio;
	description = "R Studio setup with packages";
      };
    };
  };
}
