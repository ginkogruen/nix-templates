{
  description = "ginkogruen's flake templates";

  outputs = { self, ... }: {
    templates = {
      supercollider = {
        path = ./supercollider;
	description = "A simple SuperCollider project";
      };
      rstudio = {
        path = ./rstudio;
	description = "R Studio setup with packages";
      };
    };
  };
}
