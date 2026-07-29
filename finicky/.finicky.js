// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

const workChrome = {
  name: "Google Chrome",
  profile: "Default",
};

const personalChrome = {
  name: "Google Chrome",
  profile: "Profile 1",
};

export default {
  defaultBrowser: "Google Chrome",
  options: {
    logRequests: true,
  },
  handlers: [
    // Work
    {
      match: ({ url }) =>
        url.host === "github.com" && url.pathname.startsWith("/aviva-verde/"),
      browser: workChrome,
    },
    {
      match: ({ url }) => url.host === "miro.com",
      browser: workChrome,
    },
    {
      match: ({ url }) => url.host === "teams.microsoft.com",
      browser: workChrome,
    },
    {
      match: finicky.matchHostnames([/atlassian\.(com|net)/]),
      browser: workChrome,
    },
    {
      match: ({ url }) => url.host === "aviva-verde.awsapps.com",
      browser: workChrome,
    },
    {
      match: ({ url }) => url.host === "policy.zero-admin-testing.aviva.co.uk",
      browser: workChrome,
    },
    {
      match: ({ url }) => url.host === "app.launchdarkly.com",
      browser: workChrome,
    },
    {
      match: ({ url }) => url.host === "azverde.slack.com",
      browser: workChrome,
    },
    // Personal
    {
      match: ({ url }) =>
        url.host === "github.com" && url.pathname.startsWith("/craigrosie/"),
      browser: personalChrome,
    },
  ],
};
