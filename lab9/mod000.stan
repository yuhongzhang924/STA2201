//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N; // Number of regions
  vector[N] aff_i; // Proportion of male population working outside in each region
  int<lower=0> obs[N]; // Observed deaths in each region
  vector[N] exps; // Expected deaths in each region
}

parameters {
  real mu; // Mean of intercepts
  real<lower=0> sigma; // Standard deviation of intercepts
  vector[N] alpha; // Intercept for each region
  real<lower=0> beta; // Coefficient for proportion of male population
}

transformed parameters{
  vector[N] theta;
  for (i in 1:N){
    theta[i] = alpha[i] + beta * aff_i[i];
  }
}

model {
  mu ~ normal(0,1);
  sigma ~ normal(0,1);
  alpha ~ normal(mu, sigma); // Hierarchical prior on intercepts
  obs ~ poisson(exps .* exp(theta));
}

generated quantities{
  vector[N] log_lik;
  for (i in 1:N){
  real obs_hat = exps[i] * exp(theta[i]);
  log_lik[i] = poisson_lpmf(obs[i] | obs_hat);
  }
}

