Summary: Upstart Puppet Module
Name: pupmod-upstart
Version: 4.1.0
Release: 3
License: Apache License, Version 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: puppet >= 3.3.0
Buildarch: noarch
Requires: simp-bootstrap >= 4.2.0
Obsoletes: pupmod-upstart-test

Prefix:"/etc/puppet/environments/simp/modules"

%description
This Puppet module manages the upstart daemon introduced in RHEL6.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/upstart

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/upstart
done

mkdir -p %{buildroot}/usr/share/simp/tests/modules/upstart

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

%files
%defattr(0640,root,puppet,0750)
/etc/puppet/environments/simp/modules/upstart
#%exclude /etc/puppet/environments/simp/modules/upstart/tests

%post
# Post installation stuff

%postun
# Post uninitall stuff

%changelog
* Fri Jan 16 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-3
- Changed puppet-server requirement to puppet

* Wed Apr 16 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-2
- Added the ability to disable ctrl-alt-del to the main upstart class.

* Thu Feb 12 2014 Kendall Moore <kmoore@keywcorp.com> - 4.1.0-1
- Converted all boolean strings into native booleans.

* Fri Jan 03 2014 Nick Markowski <nmarkowski@keywcorp.com> 4.1.0-0
- Updated module for puppet3/hiera compatability, optimized code for lint tests,
  and added puppet-rspec tests.

* Tue Dec 31 2013 Nick Markowski <nmarkowski@keywcorp.com> 4.1.0-0
- Updated module for puppet3/hiera compatability, and optimized code for lint tests.

* Tue Oct 08 2013 Kendall Moore <kmoore@keywcorp.com> 4.0.0-7
- Updated all erb templates to properly scope variables.

* Wed Feb 06 2013 Maintenance
4.0.0-6

* Tue Feb 05 2013 Maintenance
4.0.0-5
- Create a Cucumber test to install and configure the upstart module.

* Fri Jul 27 2012 Maintenance
4.0.0-4
- Updated the init.pp to only manage 'prompt' and 'single' since that's all
  that's really security relevant.

* Wed Apr 11 2012 Maintenance
4.0.0-3
- Updated pp files to better meet Puppet's recommended style guide.

* Fri Mar 02 2012 Maintenance
4.0.0-2
- Improved test stubs.

* Mon Dec 26 2011 Maintenance
4.0.0-1
- Updated the spec file to not require a separate file list.

* Mon Jul 25 2011 Maintenance
4.0.0-0
- Initial release of upstart module.
