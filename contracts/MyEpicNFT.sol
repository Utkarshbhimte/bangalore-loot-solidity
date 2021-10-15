// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    string baseSvg =
        '<svg width="350" height="350" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet"><style>.base{fill:#212121;font-family:Helvetica, sans-serif;font-size:20px;font-weight:700;text-anchor:start}</style><rect fill="#000" width="100%" height="100%" />';

    string[] startupJob = [
        "A developer",
        "A techboi",
        "A designer",
        "A founder",
        "A product manager",
        "A content manager",
        "A marketer"
    ];
    string[] startupType = [
        "a fintech",
        "an edtech",
        "a dukaantech",
        "an ecommerce",
        "a defi",
        "an agro-tech",
        "a healthcare",
        "an AI",
        "a foodtech",
        "a B2B",
        "a B2C"
    ];
    string[] startupTask = [
        "finalising landing page content",
        "working on a friday night",
        "re-designing UI",
        "ignoring stand-up meetings",
        "checking analytics",
        "doing user interviews",
        "talking to investors"
    ];

    string[] bangaloreThing = [
        "after booking their cult class",
        "from a third wave cafe",
        "while eating meghana biryani",
        "while watching chess livestreams",
        "while screaming internally",
        "while checking their BTC",
        "while listening to tim ferris",
        "while checking twitter on the side",
        "while listening to audible",
        "while swiping through swiggy"
    ];

    // string[] background = [
    //     "Qmd1QZqrNicuVzDys3LU3ukdZvHTSQDqTn7cu8R8EpcvXa",
    //     "QmS7qrVQgLsKPCneNxgJFW8A5kYkuqU1LmLib4q73KC3Q8",
    //     "QmbKKLjzmb76xwJ3eA8hykfRaMFmwEof3VA6V3aBbbGi45",
    //     "QmQRyNmPkPp9HLhPyEgyAkBWWLV1r4XJnA3S9LtTH7jcn5",
    //     "QmQRyNmPkPp9HLhPyEgyAkBWWLV1r4XJnA3S9LtTH7jcn5",
    //     "QmTdiF1QrRgNimaMCShZsYN1t1R4ME3REnhQh6bwSxXeDp",
    //     "Qmf8gSvHKQ9Eyxd5A3VLnDddJZRvGrmBM5ZJPT3zeyBPCP"
    // ];

    constructor() ERC721("SquareNFT", "SQUARE") {
        // console.log("This is my NFT contract. Woah!");
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % startupJob.length;
        return startupJob[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % startupType.length;
        return startupType[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % startupTask.length;
        return startupTask[rand];
    }

    function pickRandomFourthWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FORTH_WORD", Strings.toString(tokenId)))
        );
        rand = rand % bangaloreThing.length;
        return bangaloreThing[rand];
    }

    // function pickRandomBackground(uint256 tokenId)
    //     public
    //     view
    //     returns (string memory)
    // {
    //     uint256 rand = random(
    //         string(abi.encodePacked("BG", Strings.toString(tokenId)))
    //     );
    //     rand = rand % background.length;
    //     return background[rand];
    // }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory fourth = pickRandomFourthWord(newItemId);

        string memory plainText = string(
            abi.encodePacked(
                first,
                " in ",
                second,
                " startup ",
                third,
                " ",
                fourth
            )
        );

        string memory combinedWord = string(
            abi.encodePacked(
                '<text class="base" xml:space="preserve" y="204.715" x="24.286">',
                first,
                "</text>",
                '<text class="base" xml:space="preserve" y="241.715" x="24.286">in a ',
                second,
                " startup</text>",
                '<text class="base" xml:space="preserve" y="279" x="24.297">',
                third,
                "</text>",
                '<text class="base" xml:space="preserve" y="314.715" x="24.286">',
                fourth,
                "</text>"
            )
        );

        // string memory bgId = pickRandomBackground(newItemId);
        // string memory backgroundSVG = string(
        //     abi.encodePacked(
        //         '<defs><pattern id="img1" patternUnits="userSpaceOnUse" width="350" height="350"><image preserveAspectRatio="xMinYMin slice" href="https://ipfs.infura.io/ipfs/',
        //         bgId,
        //         '" x="0" y="0" width="350" height="350" /></pattern></defs><rect fill="url(#img1)" width="100%" height="100%" />'
        //     )
        // );
        string memory backgroundSVG = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' width='350' height='350'><defs><linearGradient id='g1' gradientUnits='userSpaceOnUse' x1='-9.15%' y1='15.85%' x2='109.15%' y2='84.15%'><stop stop-color='#a1c4fd'/><stop offset='1' stop-color='#c2e9fb'/></linearGradient></defs><rect width='100%' height='100%' fill='url(#g1)'/></svg>"
            )
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, backgroundSVG, combinedWord, "</svg>")
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        plainText,
                        '", "description": "Just Bangalore TechBro things.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        // console.log("\n--------------------");
        // console.log(
        //     string(
        //         abi.encodePacked(
        //             "https://nftpreview.0xdev.codes/?code=",
        //             finalTokenUri
        //         )
        //     )
        // );
        // console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        // console.log(
        //     "An NFT w/ ID %s has been minted to %s",
        //     newItemId,
        //     msg.sender
        // );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
