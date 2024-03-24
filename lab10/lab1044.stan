data {
  int<lower=0> N; // number of observations
  int<lower=0> T; // number of years
  int<lower=0> mid_year; // mid-year of study
  vector[N] y; // log ratio
  int<lower=0> P; // number of projection years
  vector[N] se; // standard error around observations
  vector[T] years; // unique years of study
  int<lower=0> year_i[N]; // year index of observations
}

parameters {
  real<lower=-1, upper=1> rho1;
  real<lower=0> sigma;
  real<lower=0> sigma_mu; 
  vector[T] mu; 
}

model {
  y ~ normal(mu[year_i], se);
  rho1 ~ uniform(-1, 1);
  sigma_mu ~ normal(0, 1);
  mu[1] ~ normal(0, 1);
  mu[2] ~ normal( mu[1], sigma_mu);
  for (t in 3:T) {
    mu[t] ~ normal((2*mu[t-1] - mu[t-2]), sigma_mu);
  }
}

generated quantities {
  vector[P] mu_new;
  mu_new[1] = normal_rng((2*mu[T] -  mu[T-1]), sigma_mu);
  mu_new[2] = normal_rng((2* mu_new[1] - mu[T]), sigma_mu);
  for (i in 3:P) {
    mu_new[i] = normal_rng((2* mu_new[i-1] -  mu_new[i-2]), sigma_mu);
  }
}