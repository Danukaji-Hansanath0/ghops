Name:           ghops
Version:        VER
Release:        1%{?dist}
Summary:        GitHub Multi-Repo Secret Manager

License:        MIT
URL:            https://github.com/danukaji/ghops
Source0:        ghops.tar.gz

Requires:       gh

BuildArch:      noarch

%description
Interactively select GitHub repositories and bulk-set secrets
across all of them. Requires gh CLI and authentication.

%prep
%setup -q -n ghops

%install
install -Dm755 bin/ghops    %{buildroot}%{_bindir}/ghops
install -Dm644 LICENSE      %{buildroot}%{_licensedir}/ghops/LICENSE
install -Dm644 man/man1/ghops.1.gz %{buildroot}%{_mandir}/man1/ghops.1.gz
install -Dm644 completions/ghops.bash %{buildroot}%{_sysconfdir}/bash_completion.d/ghops
install -Dm644 completions/ghops.zsh  %{buildroot}%{_datadir}/zsh/site-functions/_ghops

%files
%{_bindir}/ghops
%{_licensedir}/ghops/LICENSE
%{_mandir}/man1/ghops.1.gz
%{_sysconfdir}/bash_completion.d/ghops
%{_datadir}/zsh/site-functions/_ghops

%changelog
* Fri Jun 26 2026 danukaji <danukaji@example.com> - 1.0.0-1
- Initial release
