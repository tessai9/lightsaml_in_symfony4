<?php
namespace App\Security;

use App\Security\User;
use LightSaml\Model\Protocol\Response;
use LightSaml\SpBundle\Security\User\UserCreatorInterface;
use LightSaml\SpBundle\Security\User\UsernameMapperInterface;
use Symfony\Component\Security\Core\User\UserInterface;

class UserCreator implements UserCreatorInterface
{
    /** @var UsernameMapperInterface */
    private $usernameMapper;

    /**
     * @param UsernameMapperInterface $usernameMapper
     */
    public function __construct($usernameMapper)
    {
        $this->usernameMapper = $usernameMapper;
    }

    /**
     * @param Response $response
     *
     * @return UserInterface|null
     */
    public function createUser(Response $response)
    {
        $username = $this->usernameMapper->getUsername($response);

        $user = new User();
        $user
            ->setUsername($username)
            ->setRoles(['ROLE_USER'])
        ;

        return $user;
    }
}
