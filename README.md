# symfony_image
Docker image of Symfony4 with lightSAML(SP) based on CentOS8

# How to start

This setting process is based on [Here](https://www.lightsaml.com/SP-Bundle/Getting-started/), but not saving to database.

1. Run docker image

    `$ docker run -i -t -p 8000:8000 tessai99/lightsaml_for_symfony4 /bin/bash`

2. Setup configuration for lightSAML

    1. Make user entity and user provider

    ```bash
    [root@c4cb8a0f30c5 proj] php bin/console make:user

     The name of the security user class (e.g. User) [User]:
     > User

     Do you want to store user data in the database (via Doctrine)? (yes/no) [no]:
     > no  # if you want to save to DB, input 'yes'

     Enter a property name that will be the unique "display" name for the user (e.g. email, username, uuid) [email]:
     > username

     Will this app need to hash/check user passwords? Choose No if passwords are not needed or will be checked/hashed by some other system (e.g. a single sign-on server).

     Does this app need to hash/check user passwords? (yes/no) [yes]:
     > no

     created: src/Security/User.php
     updated: src/Security/User.php
     created: src/Security/UserProvider.php
     updated: config/packages/security.yaml

      Success!

     Next Steps:
       - Review your new App\Security\User class.
       - Open src/Security/UserProvider.php to finish implementing your user provider.
       - Create a way to authenticate! See https://symfony.com/doc/current/security.html
    ```

    2. edit UserProvider.php
    ```php
    public function loadUserByUsername($username)
    {
        // edit to throw not found exception
        throw new UsernameNotFoundException();
    }
    public function refreshUser(UserInterface $user)
    {
        // return user object
        return $user;
    }
    ```

    3. add lightSAML authentication to config/packages/security.yaml
    ```yaml
    firewalls:
        main:
            anonymous: ~
            light_saml_sp:
                provider: app_user_provider
                user_creator: user_creator
                login_path: /saml/login
                check_path: /saml/login_check
                default_target_path: /
                require_previous_session: true
                logout:
                path: /logout

    access_control:
        # add path to your security routes
        - { path: ^/secure, roles: ROLE_USER }
    ```

    4. add routing to config/routes.yaml
    ```yaml
    lightsaml_sp:
        resource: "@LightSamlSpBundle/Resources/config/routing.yml"
        prefix: saml

    logout:
        path: /logout
    ```

3. That's all! Execute `$ symfony server:start` and access to `http://localhost:8000/saml/login` to start authentication!

    if you want to more configuration about lightSAML, access [here](https://www.lightsaml.com/SP-Bundle/)!

# others
- This project uses [saming](https://capriza.github.io/samling/) as default IdP. So input ACS url as `/saml/login_check`
