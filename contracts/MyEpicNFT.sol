// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    string baseSvg =
        '<svg width="350" height="350" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet"><style>.base{fill:#212121;font-family:Helvetica, sans-serif;font-size:20px;font-weight:700;text-anchor:start}</style>';

    string[] allStartupJob = [
        "A developer",
        "A techboi",
        "A designer",
        "A founder",
        "A product manager",
        "A content manager",
        "A marketer"
    ];
    string[] allStartupType = [
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
    string[] allStartupTask = [
        "finalising landing page content",
        "working on a friday night",
        "re-designing UI",
        "ignoring stand-up meetings",
        "checking analytics",
        "doing user interviews",
        "talking to investors"
    ];

    string[] allBangaloreMoments = [
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

    string[] allBackgrounds = [
        "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"
    ];

    constructor() ERC721("SquareNFT", "SQUARE") {
        // console.log("This is my NFT contract. Woah!");
    }

    function pickRandomStartupJob(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("STARTUP_JOB", Strings.toString(tokenId)))
        );
        rand = rand % allStartupJob.length;
        return allStartupJob[rand];
    }

    function pickRandomStartupType(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("STARTUP_TYPE", Strings.toString(tokenId)))
        );
        rand = rand % allStartupType.length;
        return allStartupType[rand];
    }

    function pickRandomStartupTask(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("STARTUP_TASK", Strings.toString(tokenId)))
        );
        rand = rand % allStartupTask.length;
        return allStartupTask[rand];
    }

    function pickRandomBangaloreMoment(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(
                abi.encodePacked("BANGALORE_MOMENT", Strings.toString(tokenId))
            )
        );
        rand = rand % allBangaloreMoments.length;
        return allBangaloreMoments[rand];
    }

    function pickRandomBackground(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("BG", Strings.toString(tokenId)))
        );
        rand = rand % allBackgrounds.length;
        return allBackgrounds[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomStartupJob(newItemId);
        string memory second = pickRandomStartupType(newItemId);
        string memory third = pickRandomStartupTask(newItemId);
        string memory fourth = pickRandomBangaloreMoment(newItemId);

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

        string memory currBackground = pickRandomBackground(newItemId);

        string memory backgroundSVG = string(
            abi.encodePacked(
                " <style>",
                "svg {",
                "background-size: cover;",
                'background-image: url("data:image/jpeg;base64,',
                currBackground,
                '");}</style>'
            )
        );

        string memory finalSvg = string(
            abi.encodePacked(
                baseSvg,
                backgroundSVG,
                '<defs><filter id="blurry"><feGaussianBlur stdDeviation="5" in="SourceGraphic"></feGaussianBlur></filter></defs>',
                combinedWord,
                "</svg>"
            )
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Bangalore moment #',
                        toString(newItemId),
                        '", "description": "',
                        plainText,
                        '", "image": "data:image/svg+xml;base64,',
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

        _safeMint(msg.sender, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
