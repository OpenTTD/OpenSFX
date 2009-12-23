
Name:           openttd-data-opensfx
Version:        0.2.1
%define srcver  %{version}
Release:        1%{?dist}
Summary:        OpenSFX replacement sounds for OpenTTD

Group:          Amusements/Games
License:        Creative Commons Sampling Plus 1.0
URL:            http://dev.openttdcoop.org/projects/opensfx
Source0:        http://bundles.openttdcoop.org/opensfx/releases/opensfx-%{srcver}-source.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-buildroot
BuildArch:      noarch

BuildRequires:  openttd-devel-catcodec
Requires:       openttd-data >= 0.8

Provides:       opensfx

%description
OpenSFX replacement sounds for OpenTTD. The last required step
to make OpenTTD independent..

%prep
%setup -qn opensfx-%{srcver}-source

%build
make release %{?_smp_mflags}

%install
mkdir -p %{buildroot}%{_datadir}/openttd/data/
make release-install INSTALLDIR=%{buildroot}%{_datadir}/openttd/data/

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc docs/*.txt
%dir %{_datadir}/openttd
%dir %{_datadir}/openttd/data
%{_datadir}/openttd/data/opensfx-%{srcver}.tar

%changelog
* Wed Dec 23 2009 Marcel Gmür <ammler@openttdcoop.org> - 0.2.1
- upstream update 0.2.1
* Sun Dec 13 2009 Marcel Gmür <ammler@openttdcoop.org> - 0.2.0
- rename the package and provide the old name
- only openttd-data is required (no X)
* Thu Dec 10 2009 Marcel Gmür <ammler@openttdcoop.org> - 0.2.0
- upstream update 0.2.0
* Sat Sep 19 2009 Marcel Gmür <ammler@openttdcoop.org> - 0.1.0-alpha2
- initial build

