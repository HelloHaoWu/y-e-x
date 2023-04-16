// @xiaochen
import { ConnectKitButton, ConnectKitProvider } from "connectkit";
import React from "react";
import logo from "./images/logo.png";

export default function AppHeader() {
  return (
    <header className="box-border fixed flex flex-col top-0 left-0 w-full h-[80px] z-30 border-b-0">
      <div className="flex fade-in bg-blue-500 backdrop-blur-md items-center">
        <div className="mx-auto py-[2px] ">
          <p className="m-0 font-inter font-normal leading-5 text-xs text-white">
            Scroll's Alpha Testnet is now live.
          </p>
        </div>
      </div>

      <div className="relative">
        <div className="box-border px-3 py-2 pl- absolute w-full backdrop-blur-md ">
          <div className="row2 flex flex-row justify-between items-center flex-wrap gap-y-10 max-w-full">
            <div className="flex flex-row items-center gap-6">
              <div className="mb-[2px]">
                <div className=" relative">
                  <div>
                    <a
                      href="/intro"
                      className="text-current no-underline cursor-default"
                    >
                      <div className="cursor-pointer">
                        <img src={logo} className="h-[32px] w-[32px] z-1" />
                      </div>
                    </a>
                  </div>
                </div>
              </div>
              <div className="flex items-center space-x-4 md:space-x-6 mb-[2px]">
                <div className="relative">
                  <div>
                    <a
                      href="/otc"
                      className="no-underline text-current cursor-default"
                    >
                      <div className="flex items-center gap-1 md:gap-4 py-2 cursor-pointer">
                        <p className="m-0 font-inter leading-6 text-base font-medium text-gray-500 opacity-90">
                          Otc
                        </p>
                      </div>
                    </a>
                  </div>
                </div>
                <div className="relative">
                  <div>
                    <a
                      href="/Pools"
                      className="no-underline text-current cursor-default"
                    >
                      <div className="flex items-center gap-1 md:gap-4 py-2 cursor-pointer">
                        <p className="m-0 font-inter leading-6 text-base font-medium text-gray-500 opacity-90">
                          Pool
                        </p>
                      </div>
                    </a>
                  </div>
                </div>
                <div className="relative">
                  <div>
                    <a
                      href="#"
                      className="no-underline text-current cursor-default"
                    >
                      <div className="flex items-center gap-1 md:gap-4 py-2 cursor-pointer">
                        <p className="m-0 font-inter leading-6 text-base font-medium text-gray-500 opacity-90">
                          Launch
                        </p>
                      </div>
                    </a>
                  </div>
                </div>
                <div className="relative">
                  <div>
                    <a
                      href="#"
                      className="no-underline text-current cursor-default"
                    >
                      <div className="flex items-center gap-1 md:gap-4 py-2 cursor-pointer">
                        <p className="m-0 font-inter leading-6 text-base font-medium text-gray-500 opacity-90">
                          Protfolio
                        </p>
                      </div>
                    </a>
                  </div>
                </div>
                <div className="relative">
                  <div>
                    <a
                      href="https://scroll.io/alpha/bridge"
                      className="no-underline text-current cursor-default"
                      target="_blank"
                    >
                      <div className="flex items-center gap-1 md:gap-4 py-2 cursor-pointer">
                        <p className="m-0 font-inter leading-6 text-base font-medium text-gray-500 opacity-90">
                          Bridge
                        </p>
                      </div>
                    </a>
                  </div>
                </div>
              </div>
            </div>
            <div className="flex flex-row items-center gap-6">
              <div className=" relative">
                <div className="">
                  <ConnectKitProvider>
                    <ConnectKitButton />
                  </ConnectKitProvider>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
