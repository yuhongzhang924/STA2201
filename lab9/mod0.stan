// Stan model code outline
data {
  // Define the data to be passed to Stan
  int<lower=0> N; // number of regions
  int<lower=0> obs[N]; // observed deaths
  vector[N] exps; // expected deaths
  vector[N] aff_i; // proportion of male population working outside
}


parameters {
  real alpha; // Intercept
  real<lower=0> beta; // Coefficient for proportion of male population
}

transformed parameters{
  vector[N] theta;
  for (i in 1:N){
    theta[i] = alpha + beta*aff_i[i];
  }
}

model {
  alpha ~ normal(0,1);
  beta ~ normal(0,1);
  obs ~ poisson(exps .* exp(theta));
}
generated quantities{
  vector[N] log_lik;
  for (i in 1:N){
  real obs_hat = exps[i] * exp(theta[i]);
  log_lik[i] = poisson_lpmf(obs[i] | obs_hat);
  }
}
